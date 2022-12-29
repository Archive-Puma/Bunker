{ config, lib, pkgs, modulesPath, ... }: {

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "ext4";
    };

  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

  networking.useDHCP = lib.mkDefault true;
  virtualisation.vmware.guest.enable = true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}