{ nixpkgs, system, home-manager, pkgs, nixosVersion ? "unstable", ... }:
let
    lib = nixpkgs.lib;
in rec {
    # mkHomes :: list -> attrs
    #   generates multiples homeManagerConfigurations
    mkHomes = homes: builtins.mapAttrs (user: v: mkHome ({ inherit user; } // v)) homes;

    # mkHome :: attrs -> attrs
    #   generates a homeManagerConfiguration based on the user name
    mkHome = user: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
                {
                    home = {
                        username = "${user}";
                        homeDirectory = "/home/${user}";
                        stateVersion = lib.mkDefault "23.05";
                    };
                    programs.home-manager.enable = true;
                }
            ];
        };

    # mkMachines :: list -> attrs
    #   generates multiples nixosConfigutations
    mkMachines = machines: builtins.mapAttrs (hostname: v: mkMachine ({ inherit hostname; } // v)) machines;

    # mkMachine :: attrs -> attrs
    #   generates a nixosConfiguration based on the machine hostname
    mkMachine = { hostname, hardware ? "vmware", ... }: 
        lib.nixosSystem {
            inherit system;
            modules = [
                {
                    # Networking
                    networking = {
                        hostName = lib.mkForce hostname;
                        networkmanager.enable = lib.mkDefault true;
                    };
                    # Timezone and internationalization
                    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
                    time.timeZone = lib.mkDefault "Europe/Madrid";
                    console.keyMap = lib.mkDefault "us";
                    services.xserver = {
                        layout = lib.mkDefault "us,es";
                        xkbOptions = lib.mkDefault "grp:lalt_lshift_toggle";
                    };
                    # Sound
                    sound.enable = lib.mkDefault true;
                    hardware.pulseaudio = {
                        enable = lib.mkDefault true;
                        support32Bit = lib.mkDefault true;
                        extraConfig = lib.mkDefault "unload-module module-suspend-on-idle";
                        extraClientConf = lib.mkDefault "autospawn=yes";
                    };
                    # NixOS version
                    system.stateVersion = lib.mkForce "unstable";
                    # Experimental features
                    nix.extraOptions = lib.mkForce "experimental-features = nix-command flakes";
                    # Default packages
                    environment.systemPackages = with pkgs;[
                        curl
                        git
                        wget
                    ];
                }

                ../hardware/${hardware}.nix
                ../machines/${hostname}
            ];
        };
}