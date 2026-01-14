{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      sessionist
      fzf-tmux-url
      online-status
      battery
      resurrect
      continuum
      catppuccin
    ];
  };

  # Link the tmux config file
  home.file.".config/tmux/tmux.conf".source = ../files/tmux/tmux.conf;
}
