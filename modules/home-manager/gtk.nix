{
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    font = {
      name = "JetBrainsMono NF";
      size = 12;
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    theme = {
      package = pkgs.colloid-gtk-theme;
      name = "Colloid-Dark";
    };

    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
