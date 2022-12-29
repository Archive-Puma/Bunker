{ nixpkgs, system, nixosVersion ? "unstable", ... }:
let
    lib = nixpkgs.lib;
in rec {
    # mkMachines :: list -> attrs
    #   generates multiples nixosConfigutations
    mkMachines = machines: builtins.mapAttrs (hostname: v: mkMachine ({ inherit hostname; } // v)) machines;

    # mkMachine :: attrs -> attrs
    #   generates a nixosConfiguration based on the machine hostname
    mkMachine = { hostname, hardware ? "vmware", ... }: 
        lib.nixosSystem {
            inherit nixpkgs system;

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
                }

                ../hardware/${hardware}.nix
                ../machines/${hostname}
            ];
        };
}