{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
	    name = "boot";
            type = "EF00";
            start = "1M";
            end = "1G";
            content = {
              type = "filesystem";
              extraArgs = [ "-L" "BOOT"]; 
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" "umask=0077" ]; 
            };
          };
          root = {
            name = "btrfs-root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "NIXOS" "-f"]; 
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "subvol=root" "noatime" "compress=zstd" "ssd" "space_cache=v2" ];
                };
		"/home" = {
		  mountpoint = "/home";
		  mountOptions = [ "subvol=home" "noatime" "compress=zstd" "ssd" "space_cache=v2" ];
		};
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "subvol=persist" "noatime" "compress=zstd" "ssd" "space_cache=v2" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "subvol=nix" "noatime" "noacl" "compress=zstd" "ssd" "space_cache=v2" ];
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                    mountOptions = ["subvol=swap" "noatime" "nodatacow" "compress=no"];
                  swap.swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/persist" = {
  neededForBoot = true;
};
  
}
