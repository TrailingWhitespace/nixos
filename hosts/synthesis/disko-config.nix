{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = [ "defaults" "umask=0077" ]; 
            };
          };
          root = {
            name = "btrfs-root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "NIXOS" ]; 
              subvolumes = {
                "/root" = {
                  mountOptions = [ "noatime" "compress=zstd" "ssd" "space_cache=v2" ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "noatime" "compress=zstd" "ssd" "space_cache=v2" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "noatime" "noacl" "compress=zstd" "ssd" "space_cache=v2" ];
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };
  
}