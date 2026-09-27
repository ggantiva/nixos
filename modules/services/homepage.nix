{ self, ... }:
{
  flake.modules.nixos.homepage =
    {
      config,
      lib,
      ...
    }:
    let
      subdomain = "dash";
      domain = "${subdomain}.${config.constants.domain}";
      port = 8082;
      cfg = config.custom.homepage;
    in
    {
      options.custom.homepage = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = domain;
          description = "Domain name for Homepage dashboard.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = port;
          description = "Internal port for Homepage.";
        };

        widgets = lib.mkOption {
          type = lib.types.listOf lib.types.anything;
          default = [ ];
          description = "Dashboard top widgets.";
        };

        environmentFiles = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          description = "List of environment file paths passed to Homepage for secrets.";
        };

        services = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                group = lib.mkOption {
                  type = lib.types.str;
                  default = "Services";
                  description = "Group name on Homepage (e.g. Media, Utilities).";
                };

                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Display name of the service.";
                };

                icon = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Icon name (Dashboard Icons, Simple Icons, etc.).";
                };

                href = lib.mkOption {
                  type = lib.types.str;
                  description = "Destination link.";
                };

                description = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "Short description.";
                };

                siteMonitor = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "URL to ping for live health status.";
                };

                widget = lib.mkOption {
                  type = lib.types.nullOr (lib.types.attrsOf lib.types.anything);
                  default = null;
                  description = "Homepage widget configuration.";
                };

                weight = lib.mkOption {
                  type = lib.types.int;
                  default = 0;
                  description = "Sort weight within the group (lower appears first).";
                };
              };
            }
          );
          default = { };
          description = "Auto-registered services for Homepage.";
        };
      };

      config = {
        # Default top widget: host resources
        custom.homepage.widgets = lib.mkBefore [
          {
            resources = {
              cpu = true;
              memory = true;
              disk = "/data";
              uptime = true;
              network = true;
            };
          }
        ];

        services.homepage-dashboard = {
          enable = true;
          listenPort = cfg.port;
          allowedHosts = "*";
          environmentFiles = cfg.environmentFiles;

          settings = {
            title = "Dashboard";
            theme = "dark";
            color = "slate";
            headerStyle = "clean";
            background = {
              image = config.constants.wallpaper.url;
              blur = "sm";
            };
            layout = {
              "Media" = {
                style = "row";
                columns = 4;
              };
              "Utilities" = {
                style = "row";
                columns = 4;
              };
            };
          };

          widgets = cfg.widgets;

          services =
            let
              sortedServices = lib.sort (a: b: a.weight < b.weight || (a.weight == b.weight && a.name < b.name)) (
                lib.attrValues cfg.services
              );
              byGroup = lib.groupBy (s: s.group) sortedServices;
            in
            lib.mapAttrsToList (groupName: sList: {
              "${groupName}" = map (s: {
                "${s.name}" = {
                  inherit (s) icon href;
                }
                // lib.optionalAttrs (s.description != "") { inherit (s) description; }
                // lib.optionalAttrs (s.siteMonitor != null) { inherit (s) siteMonitor; }
                // lib.optionalAttrs (s.widget != null) { inherit (s) widget; };
              }) sList;
            }) byGroup;
        };

        services.caddy.virtualHosts."*.${config.constants.domain}".extraConfig = ''
          @${subdomain} host ${cfg.domain}
          handle @${subdomain} {
            reverse_proxy localhost:${toString cfg.port}
          }
        '';

        custom.impermanence.root.directories = [ "/var/lib/private/homepage-dashboard" ];

        # Avoids issues with permissions https://github.com/nix-community/impermanence/issues/254
        systemd.services."systemd-tmpfiles-resetup" = {
          serviceConfig = {
            RemainAfterExit = lib.mkForce false;
          };
        };
      };
    };
}
