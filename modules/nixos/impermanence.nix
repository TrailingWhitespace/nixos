{lib, ...}: {
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

      "/etc/nixos"
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      # "/etc/shadow"
    ];
  };
}
