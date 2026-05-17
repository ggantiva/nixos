{
  flake.modules.homeManager.yazi = {
    config,
    pkgs,
    ...
  }: {
    programs.yazi = {
      enable = true;
      # Enable unrar support
      package = pkgs.yazi.override {_7zz = pkgs._7zz-rar;};
      shellWrapperName = "y";

      settings = {
        mgr = {
          show_hidden = true;
          ratio = [
            1
            2
            4
          ];
        };

        preview = {
          max_width = 1800;
          max_height = 2700;
        };
      };

      initLua =
        /*
        lua
        */
        ''
          -- Show symlink in status bar
          Status:children_add(function(self)
          	local h = self._current.hovered
          	if h and h.link_to then
          		return " -> " .. tostring(h.link_to)
          	else
          		return ""
          	end
          end, 3300, Status.LEFT)

          -- Show user:group of files in status bar
          Status:children_add(function()
          	local h = cx.active.current.hovered
          	if not h or ya.target_family() ~= "unix" then
          		return ""
          	end

          	return ui.Line {
          		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
          		":",
          		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
          		" ",
          	}
          end, 500, Status.RIGHT)
        '';

      ## Borrowed from Stylix
      ## https://github.com/nix-community/stylix/blob/master/modules/yazi/hm.nix
      theme = with config.scheme.withHashtag; let
        mkBoth = fg: bg: {inherit fg bg;};
      in {
        tabs = {
          active =
            (mkBoth base00 blue)
            // {
              bold = true;
            };
          inactive = mkBoth blue base01;
        };

        mode = {
          normal_main =
            (mkBoth base00 blue)
            // {
              bold = true;
            };
          normal_alt = mkBoth base00 cyan;
          select_main =
            (mkBoth base00 green)
            // {
              bold = true;
            };
          select_alt = mkBoth green base00;
          unset_main =
            (mkBoth base00 brown)
            // {
              bold = true;
            };
          unset_alt = mkBoth brown base00;
        };

        # https://github.com/sxyazi/yazi/blob/main/yazi-config/preset/theme.toml
        filetype.rules = let
          mkRule = mime: fg: {inherit mime fg;};
        in [
          (mkRule "image/*" cyan)
          (mkRule "video/*" yellow)
          (mkRule "audio/*" yellow)

          (mkRule "application/zip" magenta)
          (mkRule "application/gzip" magenta)
          (mkRule "application/tar" magenta)
          (mkRule "application/bzip" magenta)
          (mkRule "application/bzip2" magenta)
          (mkRule "application/7z-compressed" magenta)
          (mkRule "application/rar" magenta)
          (mkRule "application/xz" magenta)

          (mkRule "application/doc" green)
          (mkRule "application/pdf" green)
          (mkRule "application/rtf" green)
          (mkRule "application/vnd.*" green)

          # Use url rule for folders as folder mime types do not get checked until they are hovered
          {
            url = "*/";
            fg = blue;
          }
          (mkRule "*" base05)
        ];

        icon = let
          mkIcon = text: fg: {inherit text fg;};
        in {
          dirs = let
            mkDirIcon = name: text: fg: ((mkIcon text fg) // {inherit name;});
          in [
            (mkDirIcon ".config" "" orange)
            (mkDirIcon ".git" "" cyan)
            (mkDirIcon ".github" "" blue)
            (mkDirIcon ".npm" "" blue)
            (mkDirIcon "Desktop" "" cyan)
            (mkDirIcon "Development" "" cyan)
            (mkDirIcon "Documents" "" cyan)
            (mkDirIcon "Downloads" "" cyan)
            (mkDirIcon "Library" "" cyan)
            (mkDirIcon "Movies" "" cyan)
            (mkDirIcon "Music" "" cyan)
            (mkDirIcon "Pictures" "" cyan)
            (mkDirIcon "Public" "" cyan)
            (mkDirIcon "Videos" "" cyan)
          ];

          conds = let
            mkCondsIcon = cond: text: fg: ((mkIcon text fg) // {"if" = cond;});
          in [
            # Special files
            (mkCondsIcon "orphan" "" base05)
            (mkCondsIcon "link" "" base04)
            (mkCondsIcon "block" "" yellow)
            (mkCondsIcon "char" "" yellow)
            (mkCondsIcon "fifo" "" yellow)
            (mkCondsIcon "sock" "" yellow)
            (mkCondsIcon "sticky" "" yellow)
            (mkCondsIcon "dummy" "" red)

            # Fallback
            (mkCondsIcon "dir" "" blue)
            (mkCondsIcon "exec" "" green)
            (mkCondsIcon "!dir" "" base05)
          ];
        };
      };
    };
  };
}
