{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.config_symlinks
    outputs.homeManagerModules.zsh
    outputs.homeManagerModules.fish
    outputs.homeManagerModules.kitty
    outputs.homeManagerModules.stylix
    outputs.homeManagerModules.gtk
    outputs.homeManagerModules.qt
    outputs.homeManagerModules.xdg
    # outputs.homeManagerModules.flatpak

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    # inputs.dankMaterialShell.homeModules.dank-material-shell

    inputs.caelestia-shell.homeManagerModules.default
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowInsecure = true;
      permittedInsecurePackages = [];
    };
  };

  home = {
    username = "prabhas";
    homeDirectory = "/home/prabhas";
  };

  home.packages = with pkgs; [
    unzip
    wl-clipboard
    nautilus
    (flameshot.override {enableWlrSupport = true;})
    grim
    slurp
    bibata-cursors
    nerd-fonts.jetbrains-mono
    # winboat
    btrfs-progs
    kdePackages.kate
    fastfetch
    microfetch
    nitch
    nerdfetch
    vulkan-tools
    hyprmon
    thunar
    kdePackages.dolphin
    qbittorrent-enhanced
    yazi
    tree
    python313
    python313Packages.pip
    trashy
    vesktop
    vlc
    mpvpaper
    pipes
    tenki
    cmatrix
    ffmpeg
    ffmpegthumbnailer
    # protonvpn-gui
    obsidian
    gitkraken
    # stremio-linux-shell
    kdePackages.filelight
    jdk
    proton-authenticator
    authenticator
    # ente-auth
    seahorse
    postgresql
    termius
    age
    sops
    zathura
    #typora
    pfetch
    ipfetch
    wayvnc
    vscodium
    yt-dlp
    # heroic
    # steam
    #lutris
    tigervnc
    ani-cli
    caffeine-ng
    atlauncher
    prismlauncher
    obs-studio
    scrcpy
    nodejs_24
    # rofi
    # wofi
    fuzzel
    rofimoji
    tofi
    vicinae
    xdotool
    wtype
    ydotool
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    xclip
    xsel
    file
    # chromium
    fd
    rclone
    rclone-ui
    discord
    blueman
    bluez
    bluez-tools
    neovim
    snapper-gui
    kew
    floorp-bin
    librewolf
    # turntable

    protonup-qt # manage ProtonGE versions
    # heroic           # GOG + Epic launcher
    lutris # game manager + install scripts
    #bottles # Wine GUI for standalone games
    # wine             # Wine itself
    winetricks # install Windows dependencies
    p7zip # extract
    gamemode # performance boost while gaming
    mangohud # in-game FPS/GPU overlay
    #  wine64

    wineWow64Packages.stable
    kdePackages.kdenlive
    #openshot-qt
    shotcut
    jdk21
    openjfx21
    steam-run
    android-tools
    scrcpy
    telegram-desktop
    mpc
    kdePackages.qtmultimedia
    glava
    # (inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.withModules [
    #   qt6.qt5compat
    #   qt6.qtpositioning
    #   kdePackages.syntax-highlighting # syntax-highlighting
    #   kdePackages.kirigami # kirigami
    #   kdePackages.kdialog # kdialog
    #   qt6.qtbase # qt6-base
    #   qt6.qtdeclarative # qt6-declarative
    #   qt6.qt5compat # qt6-5compat
    #   qt6.qtimageformats # qt6-imageformats
    #   qt6.qtmultimedia # qt6-multimedia
    #   qt6.qtpositioning # qt6-positioning
    #   qt6.qtsvg # qt6-svg
    #   qt6.qttools # qt6-tools
    #   qt6.qtvirtualkeyboard # qt6-virtualkeyboard
    #   qt6.qtwayland # qt6-wayland
    #   qt6.qtquicktimeline # qt6-quicktimeline
    #   libdrm # libdrm
    #   mesa # mesa
    # ])
    pavucontrol
    hyprpwcenter
    crosspipe
    pwvucontrol
    htop
    btop
    gamescope
  ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "qtwebengine-5.15.19" # stremio
  # ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
  gtk.gtk4.theme = null;

  programs.home-manager.enable = true;

  # programs.dank-material-shell = {
  #   enable = true;
  #   enableSystemMonitoring = true;
  #   # dgop.package = inputs.dgop.packages.${pkgs.system}.default;
  #   dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # };

  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";

  # programs.spicetify = {
  #   enable = true;
  #   enabledExtensions = with spicePkgs.extensions; [
  #     adblockify
  #     hidePodcasts
  #     shuffle
  #     # beautifulLyrics
  #   ];
  #   enabledSnippets = with spicePkgs.snippets; [
  #     rotatingCoverart
  #     pointer
  #   ];
  #   theme = spicePkgs.themes.comfy;
  #   #colorScheme = "macchiato";
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  services.wayvnc = {
    enable = true;

    #  Listen on all interfaces (0.0.0.0) so it's reachable via Tailscale's IP.
    settings.address = "0.0.0.0";
    settings.port = 5900;
  };

  # services.mpd = {
  #   enable = false;
  #   musicDirectory = "~/Music";
  # };

  # # systemd.user.services.mpd = {
  # #   Unit.Description = "Music Player Daemon";
  # #   Service = {
  # #     ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${config.xdg.configHome}/mpd/mpd.conf";
  # #   };
  # #   Install = { };
  # # };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/prabhas/Music"; # wherever your local files live
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      bar.status = {
        showBattery = true;
      };
      paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
