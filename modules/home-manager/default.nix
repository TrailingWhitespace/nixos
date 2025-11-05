# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  config_symlinks = import ./config_symlinks.nix;
  zsh = import ./zsh.nix;
  fish = import ./fish.nix;
  kitty = import ./kitty.nix;
  stylix = import ./stylix.nix;
  # flatpak = import ./flatpak.nix;
}
