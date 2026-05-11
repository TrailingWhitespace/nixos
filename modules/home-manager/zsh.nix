{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    eza
    zoxide
    fzf          # fuzzy finder — powers Ctrl+R history search
    bat          # better cat, used by fzf previews
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "$HOME/.config/zsh/.zsh_history";
      size = 100000;
      save = 100000;        # match save to size — your original bug
      append = true;        # fixes noappendhistory — no more overwriting!
      share = true;
      ignoreAllDups = false; # keep all history, just skip consecutive dups
      ignoreDups = true;
      ignoreSpace = true;   # commands prefixed with space aren't saved
      extended = true;      # save timestamps
      expireDuplicatesFirst = false;
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"           # double-tap ESC to prepend sudo
        "colored-man-pages"
        "zoxide"
        "z"
        "fzf"            # Ctrl+R fuzzy history, Ctrl+T file finder, Alt+C cd
        "extract"        # 'x archive.tar.gz' extracts anything
        "copypath"       # copies current dir path to clipboard
        "dirhistory"     # Alt+Left/Right to navigate dir history
        "command-not-found" # suggests package when command is missing
      ];
    };

    initContent = ''
      # --- Completion styling ---
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive tab complete
      zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
      setopt AUTO_MENU
      setopt CORRECT
      setopt GLOB_COMPLETE
      setopt AUTO_CD          # type a dir name to cd into it
      setopt PUSHD_IGNORE_DUPS

      # --- Aliases ---
      alias ns="sudo nixos-rebuild switch --flake ~/nixos#synthesis"
      alias hm="home-manager switch --flake ~/nixos#prabhas@synthesis"
      alias flakeupdate="nix flake update ~/nixos"
      alias cls="clear"
      alias ls="eza --long --color=always --icons=always --no-user"
      alias lla="eza --long --all --color=always --icons=always --no-user"
      alias lt="eza --tree --color=always --icons=always --level=2"
      alias emptytrash="trash empty --all"
      alias trashl="trash list"
      alias cat="bat --style=plain"   # bat as cat replacement
      alias grep="grep --color=auto"
      alias vnc="sudo tailscale up && tailscale status && systemctl --user start wayvnc && tailscale ip -4 && journalctl --user -u wayvnc -n 20"
      alias vnc-stop="sudo tailscale down && systemctl --user stop wayvnc"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
      "--preview='bat --color=always --style=numbers {} 2>/dev/null || cat {}'"
    ];
  };

  programs.starship.enable = true;
}