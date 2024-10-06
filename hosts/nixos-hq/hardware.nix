{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      kernelModules = [ ];
    };

    kernelModules = [ ];
    extraModulePackages = [ ];

    loader.grub = {
      enable = true;
      efiSupport = true;
      devices = [ "/dev/vda" ];
    };
  };

  hardware.disk.generic-btrfs-root = {
    enable = true;
    disk = "/dev/vda";
    mbrSupport = true;
  };

  hardware.qemu-guest.enable = true;

  networking = {
    hostName = "nixos-hq";
    useNetworkd = true;
    useDHCP = true;
  };
}
