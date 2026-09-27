import os
import sys
from kitty.fast_data_types import (
    GLFW_RELEASE,
    Screen,
    get_boss,
    get_options,
    set_tab_being_dragged,
    wcswidth,
)
from kitty.rgb import alpha_blend
from kitty.tab_bar import (
    CellRange,
    DrawData,
    ExtraData,
    TabBar,
    TabBarData,
    TabExtent,
    as_rgb,
    draw_tab_with_fade,
)
from kitty.tabs import TabManager
from kitty.utils import color_as_int

# --- Configuration & Icons ---
WINDOW_ICON = " "
SESSION_ICON = "󱂬 "
TITLE_MAX_CHARS = 30


# --- Helpers ---
def truncate_title(title: str, max_chars: int = TITLE_MAX_CHARS) -> str:
    if len(title) > max_chars:
        return title[: max_chars - 1] + "…"
    return title


def clean_session_name(name: str) -> str:
    if not name:
        return ""
    name = os.path.basename(name)
    if name.endswith(".kitty-session"):
        name = name[: -len(".kitty-session")]
    return name


# --- Data Providers (Modules) ---
def get_app_name(tab: TabBarData, draw_data: DrawData) -> str:
    """Module: Retrieves active window's foreground process / app name."""
    boss = get_boss()
    if not boss:
        return ""
    w = None
    if hasattr(boss, "os_window_map"):
        tm = boss.os_window_map.get(draw_data.os_window_id)
        if tm and getattr(tm, "active_window", None):
            w = tm.active_window
    if not w and hasattr(boss, "active_window") and boss.active_window:
        w = boss.active_window

    if w:
        try:
            exe = w.get_exe_of_child()
            if exe:
                return os.path.basename(exe)
        except Exception:
            pass
        try:
            if w.child and w.child.argv:
                return os.path.basename(w.child.argv[0])
        except Exception:
            pass
        return getattr(w, "title", "") or ""
    return ""


_last_session_name = ""


def get_session_name(tab: TabBarData, draw_data: DrawData) -> str:
    """Module: Resolves active session name across tabs and window managers."""
    global _last_session_name
    name = tab.active_session_name or tab.session_name
    if name:
        _last_session_name = clean_session_name(name)
        return _last_session_name

    boss = get_boss()
    if boss:
        if hasattr(boss, "active_session") and boss.active_session:
            _last_session_name = clean_session_name(boss.active_session)
            return _last_session_name
        if hasattr(boss, "os_window_map"):
            tm = boss.os_window_map.get(draw_data.os_window_id)
            if tm:
                if getattr(tm, "created_in_session_name", None):
                    _last_session_name = clean_session_name(tm.created_in_session_name)
                    return _last_session_name
                for t in getattr(tm, "tabs", ()):
                    if getattr(t, "created_in_session_name", None):
                        _last_session_name = clean_session_name(
                            t.created_in_session_name
                        )
                        return _last_session_name
                    if getattr(t, "active_session_name", None):
                        _last_session_name = clean_session_name(t.active_session_name)
                        return _last_session_name
                for w in getattr(tm, "windows", ()):
                    if getattr(w, "created_in_session_name", None):
                        _last_session_name = clean_session_name(
                            w.created_in_session_name
                        )
                        return _last_session_name
        if hasattr(boss, "all_loaded_session_names"):
            for s in boss.all_loaded_session_names:
                if s:
                    _last_session_name = clean_session_name(s)
                    return _last_session_name

    return _last_session_name


def get_session_colors(draw_data: DrawData):
    """Module: Resolves colors for session badge dynamically from theme options."""
    try:
        opts = get_options()
        if opts and hasattr(opts, "color3") and opts.color3 is not None:
            return opts.color3, draw_data.active_fg
    except Exception:
        pass
    return getattr(draw_data, "active_bg", None), draw_data.active_fg


def estimate_tab_width(tab_index: int, is_stack: bool, is_misc: bool) -> int:
    txt = ("#" if is_stack else "") + ("@" if is_misc else str(tab_index))
    return len(txt) + 3


def estimate_total_tabs_width(draw_data: DrawData, current_tab: TabBarData) -> int:
    boss = get_boss()
    if boss and hasattr(boss, "os_window_map"):
        tm = boss.os_window_map.get(draw_data.os_window_id)
        if tm and hasattr(tm, "tabs_to_be_shown_in_tab_bar"):
            shown_tabs = tuple(tm.tabs_to_be_shown_in_tab_bar)
            if shown_tabs:
                return sum(
                    estimate_tab_width(
                        i, t.current_layout.name == "stack", t.title == "misc-tab"
                    )
                    for i, t in enumerate(shown_tabs, 1)
                )
    return estimate_tab_width(
        1, current_tab.layout_name == "stack", current_tab.title == "misc-tab"
    )


# --- Section Renderers & Click Boundary Tracking ---
_tabs_start_x = 0
_session_start_x = 999999


def draw_left_section(draw_data: DrawData, screen: Screen, tab: TabBarData) -> int:
    """Renders the Left Section (App Name) and positions the cursor for the middle tabs."""
    global _tabs_start_x

    default_bg = as_rgb(int(draw_data.default_bg))
    default_fg = as_rgb(int(draw_data.inactive_fg))

    screen.cursor.x = 0
    screen.cursor.bg = default_bg
    screen.cursor.fg = default_fg
    screen.cursor.bold = False
    screen.cursor.italic = False

    app_name = get_app_name(tab, draw_data)
    left_text = f" {WINDOW_ICON}{truncate_title(app_name)} " if app_name else ""

    total_tabs_width = estimate_total_tabs_width(draw_data, tab)
    session_name = get_session_name(tab, draw_data)
    right_len = (
        2 * len(draw_data.alpha)
        + wcswidth(f"{SESSION_ICON}{truncate_title(session_name)}")
    ) if session_name else 0

    left_len = wcswidth(left_text) if left_text else 0
    max_left = max(0, screen.columns - total_tabs_width - right_len - 4)
    if left_len > max_left:
        if max_left > 4:
            left_text = left_text[: max_left - 2] + "… "
        else:
            left_text = ""

    if left_text:
        screen.cursor.bold = True
        screen.draw(left_text)
        screen.cursor.bold = False

    left_end = screen.cursor.x
    ideal_center = max(0, (screen.columns - total_tabs_width) // 2)
    _tabs_start_x = max(left_end + 1, ideal_center)

    if _tabs_start_x > screen.cursor.x:
        screen.cursor.bg = default_bg
        screen.draw(" " * (_tabs_start_x - screen.cursor.x))

    return screen.cursor.x


def draw_tab_section(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Renders a single tab in the middle section with fade styling and active/inactive colors."""
    tab_before = screen.cursor.x
    screen.cursor.bg = as_rgb(draw_data.tab_bg(tab))
    screen.cursor.fg = as_rgb(draw_data.tab_fg(tab))
    screen.cursor.bold = True if tab.is_active else False
    screen.cursor.italic = False

    return draw_tab_with_fade(
        draw_data, screen, tab, tab_before, max_title_length, index, is_last, extra_data
    )


def draw_right_section(draw_data: DrawData, screen: Screen, tab: TabBarData) -> int:
    """Renders the Right Section (Session Name) with fade styling flush to the right edge."""
    global _session_start_x

    session_name = get_session_name(tab, draw_data)
    if not session_name:
        _session_start_x = screen.columns
        return screen.cursor.x

    default_bg = as_rgb(int(draw_data.default_bg))
    session_text = f"{SESSION_ICON}{truncate_title(session_name)}"
    session_bg, session_fg = get_session_colors(draw_data)

    fade_colors = [
        as_rgb(
            color_as_int(alpha_blend(session_bg, draw_data.default_bg, alpha))
        )
        for alpha in draw_data.alpha
    ]

    badge_len = len(fade_colors) + wcswidth(session_text) + len(fade_colors)
    _session_start_x = max(screen.cursor.x, screen.columns - badge_len)
    draw_spaces = _session_start_x - screen.cursor.x
    if draw_spaces > 0:
        screen.cursor.bg = default_bg
        screen.draw(" " * draw_spaces)

    screen.cursor.x = _session_start_x

    # Leading fade space(s)
    for bg in fade_colors:
        screen.cursor.bg = bg
        screen.draw(" ")

    # Session content
    screen.cursor.bg = as_rgb(color_as_int(session_bg))
    screen.cursor.fg = as_rgb(color_as_int(session_fg))
    screen.cursor.bold = True
    screen.cursor.italic = False
    screen.draw(session_text)
    screen.cursor.bold = False

    # Trailing fade space(s)
    for bg in reversed(fade_colors):
        screen.cursor.bg = bg
        screen.draw(" ")

    return screen.cursor.x


def finalize_tab_bar(screen: Screen) -> None:
    """Finalizes tab bar rendering by advancing cursor to right edge."""
    screen.cursor.x = screen.columns


# --- Kitty Runtime Patches for Tab Extents & Mouse Clicks ---
if not getattr(TabBar, "_custom_tab_bar_patched", False):
    _orig_tab_bar_update = TabBar.update

    def _custom_tab_bar_update(self, data):
        res = _orig_tab_bar_update(self, data)
        if self.tab_extents and _tabs_start_x > 0:
            te0 = self.tab_extents[0]
            if te0.x.start < _tabs_start_x:
                new_te0 = TabExtent(
                    tab_id=te0.tab_id,
                    x=CellRange(_tabs_start_x, te0.x.end),
                    y=te0.y,
                )
                self.tab_extents = (new_te0,) + tuple(self.tab_extents[1:])
        return res

    TabBar.update = _custom_tab_bar_update
    TabBar._custom_tab_bar_patched = True

if not getattr(TabManager, "_custom_mouse_patched", False):
    _orig_handle_tab_bar_mouse = TabManager.handle_tab_bar_mouse

    def _custom_handle_tab_bar_mouse(
        self, x: float, y: float, button: int, modifiers: int, action: int
    ) -> None:
        try:
            tb = self.tab_bar
            if tb.laid_out_once and tb.cell_width > 0:
                g = tb.window_geometry
                if g.left <= x < g.right and g.top <= y < g.bottom:
                    cell_x = int((x - g.left) // tb.cell_width)
                    # Suppress clicks on left widget (app name) and right widget (session badge)
                    if cell_x < _tabs_start_x or cell_x >= _session_start_x:
                        if action == GLFW_RELEASE:
                            set_tab_being_dragged()
                        self.recent_tab_bar_mouse_events.clear()
                        return
        except Exception:
            pass
        return _orig_handle_tab_bar_mouse(self, x, y, button, modifiers, action)

    TabManager.handle_tab_bar_mouse = _custom_handle_tab_bar_mouse
    TabManager._custom_mouse_patched = True


# --- Main Coordinator ---
def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # 1. Layout pass: only measure individual tab width
    if extra_data.for_layout:
        return draw_tab_with_fade(
            draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
        )

    # 2. Draw Left Section (on first tab)
    if index == 1:
        draw_left_section(draw_data, screen, tab)

    # 3. Draw Tab (middle section)
    tab_end = draw_tab_section(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )

    # 4. Draw Right Section & Finalize (on last tab)
    if is_last:
        draw_right_section(draw_data, screen, tab)
        finalize_tab_bar(screen)

    return tab_end
