{
  lib,
  pkgs,
  ...
}: {
  boot.initrd.systemd.enable = true;

  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume";
    wantedBy = [ "initrd.target" ];
    after = [ "local-fs-pre.target" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /btrfs_tmp
      mount -t btrfs -o subvolid=5 /dev/disk/by-label/NIXOS /btrfs_tmp

      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

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
