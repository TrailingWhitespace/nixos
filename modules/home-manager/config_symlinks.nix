{
  config,
  lib,
  ...
}: let
  homeDirectory = config.home.homeDirectory;
in {
  home.file = {
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/nixos/config/hypr";
    };

    ".config/flameshot.ini" = {
      source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/nixos/config/flameshot.ini";
    };
  };
}
