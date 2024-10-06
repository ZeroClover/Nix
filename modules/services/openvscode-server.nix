{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.zero.services.openvscode-server;
in
{
  options.zero.services.openvscode-server = {
    enable = mkEnableOption "Enable OpenVSCode server module";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "openvscode-server-token" = {
        sopsFile = config.sops-file.get "openvscode-server";
        owner = "zero";
      };
    };

    networking.firewall.allowedTCPPorts = [ 4444 ];

    services.openvscode-server = {
      enable = true;
      user = "zero";
      group = "users";
      host = "0.0.0.0";
      port = 4444;
      connectionTokenFile = config.sops.secrets.openvscode-server-token.path;

      package = pkgs.vscode-with-extensions.override {
        vscode = pkgs.openvscode-server.overrideAttrs { passthru.executableName = "openvscode-server"; };
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          dracula-theme.theme-dracula
          editorconfig.editorconfig
          arrterian.nix-env-selector
          oderwat.indent-rainbow
          christian-kohler.path-intellisense
          mkhl.direnv
          # Formatter
          hookyqr.beautify
          # Git Plugins
          donjayamanne.githistory
          eamodio.gitlens
          # Golang
          golang.go

          spywhere.guides
          pkief.material-icon-theme
          ryu1kn.partial-diff
          # ms-python.python
          ms-azuretools.vscode-docker
          octref.vetur
          equinusocio.vsc-material-theme
          jnoortheen.nix-ide
        ];
      };
    };
  };
}
