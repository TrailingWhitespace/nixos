# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    # ./hardware-configuration.nix

    inputs.impermanence.nixosModules.impermanence
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "rtsx_usb_sdmmc" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  


 
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS"; # Use the label you set in disko
    fsType = "btrfs";
    options = [ "subvol=root" "noatime" "compress=zstd" "ssd" "space_cache=v2" ];
  };

  
  # This runs on every boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    # Mount the top-level BTRFS partition (labeled NIXOS)
    mkdir /btrfs_tmp
    mount -o subvolid=5 /dev/disk/by-label/NIXOS /btrfs_tmp

    # Check if our 'root' subvolume exists to be snapshotted
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    # Recursive delete function
    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    # Delete roots older than 30 days
    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    # Create the new, clean 'root' subvolume for this boot
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';






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

   environment.systemPackages = with pkgs; [
git  firefox 
vscode kitty ];


fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  users.users = {

    prabhas = {
      isNormalUser = true;
      description = "Me ig.";
      extraGroups = ["wheel" "networkmanager"];
      initialPassword = "temp123";
    };
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
