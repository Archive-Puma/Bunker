{ config, lib, ... }: {

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
  virtualisation.vmware.guest.enable = lib.mkForce true;

  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.version = lib.mkDefault 2;
  boot.loader.grub.device = lib.mkDefault "/dev/sda";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}