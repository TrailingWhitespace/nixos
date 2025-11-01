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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
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
      serif = [  "Liberation Serif"  ];
      sansSerif = [ "Ubuntu" ];
      monospace = [ "JetBrainsMono NF" "Ubuntu Mono" ];
    };
  };
};

virtualisation.docker = {
  enable = true;

 extraPackages = [ pkgs.docker-buildx ];
};
virtualisation.docker.storageDriver = "btrfs";


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
