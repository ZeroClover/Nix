{ config, lib, ... }:

with lib;
let
  cfg = config.zero.hardware.zram;
in
{
  options.zero.hardware.zram = {
    enable = mkEnableOption "Enable zram module";

    size = mkOption {
      type = types.str;
      default = "ram / 2";
    };
  };

  config = mkIf cfg.enable {
    services.zram-generator = {
      enable = true;
      settings.zram0 = {
        compression-algorithm = "zstd";
        zram-size = cfg.size;
        swap-priority = 100;
      };
    };

    # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    boot.kernel.sysctl = {
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
      "vm.swappiness" = 180;
    };
  };
}
