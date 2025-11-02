{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    outputs.nixosModules.impermanence

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    inputs.impermanence.nixosModules.impermanence
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems."/persist" = {
    neededForBoot = true;
  };

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
    };
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };

    optimise = {
      automatic = true;
    };
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.devices = ["/dev/nvme0n1"];
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.networkmanager.enable = true;

  networking.hostName = "synthesis";

  programs.hyprland.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  time.timeZone = "Asia/Kolkata";

  environment.systemPackages = with pkgs; [
    git
    firefox
    vscode
    kitty
  ];

  users.users = {
    prabhas = {
      isNormalUser = true;
      description = "Me ig.";
      extraGroups = ["wheel" "networkmanager" "docker"];
      initialPassword = "temp123";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu-classic
      liberation_ttf
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Liberation Serif"];
        sansSerif = ["Ubuntu"];
        monospace = ["JetBrainsMono NF" "Ubuntu Mono"];
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    extraPackages = [pkgs.docker-buildx];
  };
  virtualisation.docker.storageDriver = "btrfs";

  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "mem_sleep_default=deep"

      # "resume=UUID=301e26ea-dacc-4fbc-814f-653ec5be11b8"
      "resume_offset=533760"
      # ^^^ don't use filefrag on btrfs! (thats the wrong offset)
      # btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    ];

    consoleLogLevel = 3;
    initrd.verbose = false;
    loader.timeout = 5;
    supportedFilesystems = ["btrfs" "exfat"];
  };

  swapDevices = [
    {
      device = "/.swapvol/swapfile";
      size = 16384; # in MB (16G)
    }
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/301e26ea-dacc-4fbc-814f-653ec5be11b8";
  # ^^^ UUID of /dev/nvme0n1p2 (btrfs-root/root) from 'lsblk -f'
  powerManagement.enable = true;

  services.logind.settings = {
    Login = {
      SleepOperation = "suspend";

      IdleAction = "suspend";
      IdleActionSec = "5min";

      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "suspend";
    };
  };

  hardware.graphics = {
    # hardware.opengl
    enable = true;

    extraPackages = [
      pkgs.intel-media-driver
      pkgs.libva
      pkgs.libva-utils
    ];
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  services.thermald.enable = true;
  services.tlp = {
    enable = true;

    settings = {
      # CPU governors
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "ondemand"; # Balanced mode

      # Energy performance policy
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # CPU min/max performance (%)
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60; # Balanced for battery

      # Battery charge thresholds (helps long-term health)
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # Optional extra savings
      USB_AUTOSUSPEND = 1; # Enable USB suspend on battery
      DISK_IDLE_SECS_ON_BAT = 2; # Spin down disks quickly
      WIFI_PWR_ON_BAT = "on"; # Wi-Fi power save enabled
    };
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
