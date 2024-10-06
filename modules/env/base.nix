{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.zero.env.base;
in
{
  options.zero.env.base = {
    enable = mkEnableOption "Enable base env";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    security.sudo.extraRules = [
      {
        users = [ "zero" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    users = {
      mutableUsers = false;
      users.zero = {
        hashedPassword = "$6$PMi4RX.RMlh2M.l1$akzUwJf3qII5I/r/GQBKpAYZh5wewNkTCuasPSEiWiTZSdn7uunHXJJeY7742klZPm.zVsAg8fD91DY5DE5JS.";
        isNormalUser = true;
        home = "/home/zero";
        description = "Zero";
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "libvirtd"
          "qemu-libvirtd"
          "kvm"
        ];
        shell = pkgs.zsh;
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;

      autosuggestions.enable = true;
      autosuggestions.extraConfig.ZSH_AUTOSUGGEST_USE_ASYNC = "y";

      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [
        "main"
        "brackets"
        "pattern"
        "root"
        "line"
      ];

      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "sudo"
          "docker"
          "direnv"
        ];
      };
    };
  };
}
