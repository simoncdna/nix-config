{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    terminal = "screen-256color";
    escapeTime = 0;
    historyLimit = 10000;

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

    extraConfig = ''
      # Pane base index
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Terminal overrides
      set -ga terminal-overrides ",foot:Tc"

      # Pane resizing
      bind -r C-k resize-pane -U
      bind -r C-j resize-pane -D
      bind -r C-h resize-pane -L

      # Copy mode
      bind-key v copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      # Go to previous window
      bind -r O switch-client -l
      bind -r o last-window
      bind -r ^ switch-client -l

      # Go to previous/next session
      bind -r N switch-client -n
      bind -r P switch-client -p

      # Vim like pane splitting
      bind H split-window -v
      bind V split-window -h

      # Undercurl
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Toggle tmux status bar
      bind '\' set status
      if-shell "[[ $(tmux lsw | wc -l) -le 1 ]]" 'set -g status'

      set -g status on

      # Plugin settings - resurrect
      set -g @resurrect-capture-pane-contents 'on'

      # Plugin settings - continuum
      set -g @continuum-restore 'on'

      # Plugin settings - catppuccin
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_status_background "none"
      set -g @catppuccin_window_status_style "none"
      set -g @catppuccin_pane_status_enabled "off"
      set -g @catppuccin_pane_border_status "off"

      # Configure Online status
      set -g @online_icon "ok"
      set -g @offline_icon "nok"

      # status left look and feel
      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

      # status right look and feel
      set -g status-right-length 100
      set -g status-right ""
      set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
      set -ga status-right "#[bg=#{@thm_bg}]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"

      # Configure Tmux status bar
      set -g status-position bottom
      set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "absolute-centre"

      # window look and feel
      set -wg automatic-rename on
      set -g automatic-rename-format "#{pane_current_command}"

      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
      set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"

      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"
    '';
  };
}
