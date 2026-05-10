{ lib, pkgs, ... }: {
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










# boot.initrd.systemd.enable = true;

# boot.initrd.systemd.initrdBin = with pkgs; [
#   busybox
#   coreutils
#   util-linux
#   btrfs-progs
#   findutils
# ];

# boot.initrd.systemd.services.rollback = {
#   description = "Rollback BTRFS root subvolume";
#   wantedBy = [ "initrd.target" ];
#   after = [
#     "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2dbtrfs\\x2droot.device"
#     "systemd-modules-load.service"
#   ];
#   before = [
#     "sysroot.mount"
#     "local-fs-pre.target"
#   ];
#   # conflicts = [ "local-fs-pre.target" ];
#   unitConfig.DefaultDependencies = "no";
#   serviceConfig.Type = "oneshot";
#   script = ''
#     mkdir /btrfs_tmp
#     mount -t btrfs -o subvolid=5 /dev/disk/by-partlabel/disk-main-btrfs-root /btrfs_tmp

#     if [[ -e /btrfs_tmp/root ]]; then
#         mkdir -p /btrfs_tmp/old_roots
#         timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
#         mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
#     fi

#     delete_subvolume_recursively() {
#         IFS=$'\n'
#         for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
#             delete_subvolume_recursively "/btrfs_tmp/$i"
#         done
#         btrfs subvolume delete "$1"
#     }

#     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
#         delete_subvolume_recursively "$i"
#     done

#     btrfs subvolume create /btrfs_tmp/root
#     umount /btrfs_tmp
#   '';
# };






  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib"
      "/var/spool"
      "/var/db" # /var/db/sudo/lectured -- persist to not show that running sudo for the first time disclaimer thing every time

      # "/root"
      # "/srv"

      # "/etc"

      # "/etc/nixos"
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"

      # "/nix/var/nix/profiles/per-user"
    # "/nix/var/nix/gcroots/per-user"
    

    # "/var/lib/bluetooth"
    # "/var/lib/nixos"
    # "/var/lib/tailscale"
    ];
    files = [
      "/etc/machine-id"
      # "/etc/shadow"
      # "/etc/group"
      # "/etc/passwd"
    ];

    users.prabhas = {
      directories = [
        ".config/sops"
        ".ssh"
        # ".local/state/nix"
      ];
    };
  };
}
