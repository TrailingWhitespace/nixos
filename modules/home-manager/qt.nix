{
  lib,
  pkgs,
  config,
  ...
}: {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "kvantum";
      package = pkgs.layan-gtk-theme;
    };
  };
}
