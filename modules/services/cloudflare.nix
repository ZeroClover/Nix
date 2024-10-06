{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.zero.services.cloudflare;
in
{
  options.zero.services.cloudflare = {
    enable = mkEnableOption "Enable Cloudflare Tunnel Service";

    secretName = mkOption {
      example = "cloudflare-token";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."${cfg.secretName}" = { };

    systemd.services.cloudflare-tunnel = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      description = "Cloudflare Tunnel";

      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        NoNewPrivileges = true;
        LoadCredential = [ "cloudflare-token:${config.sops.secrets."${cfg.secretName}".path}" ];
      };

      path = with pkgs; [ cloudflared ];

      script = ''
        exec cloudflared tunnel --no-autoupdate run --token `cat $CREDENTIALS_DIRECTORY/cloudflare-token`
      '';
    };
  };
}
