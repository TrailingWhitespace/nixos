# SDDM is a display manager for X11 and Wayland
{
  pkgs,
  inputs,
  config,
  ...
}: let
 
  
  sddm-astronaut = pkgs.sddm-astronaut.override {  
    embeddedTheme = "pixel_sakura";
  };
in {
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme"; 
    };
  };

  environment.systemPackages = [sddm-astronaut];
}