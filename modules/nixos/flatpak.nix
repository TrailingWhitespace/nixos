# Why doesn't this work as a home manager module?
# Is it because im using home manager as standalone instead of as a module? (probably)

{ lib, ... }: {
  # Add a new remote. Keep the default one (flathub)
  # services.flatpak.remotes = lib.mkOptionDefault [{
  #   name = "flathub-beta";
  #   location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  # }];
  
  services.flatpak.update.onActivation = false;
  services.flatpak.update.auto = {
  enable = true;
  # onCalendar = "weekly"; # Default value
};
  services.flatpak.uninstallUnmanaged = true; 
  
  # Dont think I'd be installing from the cli anymore so yeah
  # NOTE: This works differently when nix-flatpak is used as a home manager module and a nixos module
  # Only manages system wide installed packages if used as a nixos module and vice versa.
  # Ref: https://github.com/gmodena/nix-flatpak#unmanaged-packages-and-remotes
  services.flatpak.uninstallUnused = true;
  # To uninstall packages if they are removed from `flatpak.packages`

  # Add here the flatpaks you want to install
  services.flatpak.packages = [
    "com.stremio.Stremio"
    "app.zen_browser.zen"
    "io.github.nozwock.Packet"
    "com.usebottles.bottles"
    "net.nokyan.Resources"
    "com.protonvpn.www"
    "io.github.kolunmi.Bazaar"
    "io.github.flattool.Warehouse"
    "io.github.aandrew_me.ytdn"
    "org.gnome.baobab"
    "com.jetbrains.IntelliJ-IDEA-Community"
    "me.proton.Pass"
    "com.github.marhkb.Pods"
    "io.github.ppvan.tarug"
    "io.beekeeperstudio.Studio"
    "org.kde.index"
    "dev.deedles.Trayscale"
    "org.gnome.Logs"
    "com.github.paolostivanin.OTPClient"
    "best.ellie.StartupConfiguration"
    "org.kde.kdf"
    "io.github.qier222.YesPlayMusic"
    "io.bassi.Amberol"
    "com.github.neithern.g4music"
    "com.pojtinger.felicitas.Multiplex"
    "org.kde.audiotube"
    # "io.ente.auth"
  ];


  # Also look at: https://github.com/gmodena/nix-flatpak#overrides
}