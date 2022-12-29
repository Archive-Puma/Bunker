{ nixpkgs, system, nixosVersion ? "unstable", ... }: rec {
    # mkMachines :: list -> attrs
    #   generates multiples nixosConfigutations
    mkMachines = machines: builtins.mapAttrs (hostname: v: mkMachine ({ inherit hostname; } // v)) machines;

    # mkMachine :: attrs -> attrs
    #   generates a nixosConfiguration based on the machine hostname
    mkMachine = { hostname, hardware ? "vmware", ... }: 
        nixpkgs.lib.nixosSystem {
            inherit nixpkgs system;

            modules = [
                ../hardware/${hardware}.nix
                ../machines/${hostname}.nix

                {
                    # Enable nix flakes
                    #nix.package = pkgs.nixFlakes;
                    #nix.extraOptions = "experimental-features = nix-command flakes";
                    # Hostname
                    networking.hostName = hostname;
                    # Enable the NixOS Manual
                    system.stateVersion = "unstable";
                }
            ];
        };
}