{config, ...}: {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";
    userDirs = {
      enable = true;
      createDirectories = false;
      extraConfig = {
        XDG_DEV_DIR = "${config.home.homeDirectory}/Dev";
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Screenshots";
        XDG_WALLPAPERS_DIR = "${config.home.homeDirectory}/Wallpapers";
      };
    };
    mimeApps = let
      imageViewer = ["org.gnome.Loupe"];
      audioPlayer = ["io.bassi.Amberol"];
      videoPlayer = ["io.github.celluloid_player.Celluloid"];
      webBrowser = ["firefox"];

      xdgAssociations = type: program: list:
        builtins.listToAttrs (map (e: {
            name = "${type}/${e}";
            value = program;
          })
          list);

      image = xdgAssociations "image" imageViewer ["png" "svg" "jpeg" "gif"];
      audio = xdgAssociations "audio" audioPlayer ["mp3" "flac" "wav" "aac"];
      video = xdgAssociations "video" videoPlayer ["mp4" "avi" "mkv"];
      browser =
        (xdgAssociations "application" webBrowser [
          "pdf"
          "json"
          "x-extension-htm"
          "x-extension-html"
          "x-extension-shtml"
          "x-extension-xht"
          "x-extension-xhtml"
        ])
        // (xdgAssociations "x-scheme-handler" webBrowser [
          "about"
          "ftp"
          "http"
          "https"
          "unknown"
        ]);

      # XDG MIME types
      associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) ({
          "text/html" = webBrowser;
          "text/plain" = ["code"];
          "inode/directory" = ["nautilus"];
        }
        // image
        // audio
        // video
        // browser);
    in {
      enable = true;
      defaultApplications = associations;
    };
  };
}
