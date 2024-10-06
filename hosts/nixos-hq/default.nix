{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  deployment.targetHost = "43.153.149.50";

  zero.services.ssh.enable = true;
  zero.env.base.enable = true;
  indexyz.environment.base.enable = true;
  zero.services.openvscode-server.enable = true;

  environment.systemPackages = with pkgs; [ nil ];
}
