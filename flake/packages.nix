{ inputs, ... }:

{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  perSystem =
    {
      inputs',
      config,
      pkgs,
      self',
      ...
    }:
    rec {
      packages = {
        
      };
      overlayAttrs = packages;
    };
}
