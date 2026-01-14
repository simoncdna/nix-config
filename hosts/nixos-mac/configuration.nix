# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./apple-silicon-support
    ];

  # Disable automatic firmware extraction (it's already installed)
  hardware.asahi.extractPeripheralFirmware = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Default Shell
  programs.zsh = {
  	enable = true;

	autosuggestions.enable = true;
	syntaxHighlighting.enable = true;

	ohMyZsh = {
		enable = true;
		theme = "robbyrussell";
		plugins = [ "git" "sudo" "history" "fzf" "web-search" ];
	};
  };

  programs.starship.enable = true;

  # Tmux
  programs.tmux = {
    enable = true;
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
        set-option -g prefix C-Space
     
        # Enable mouse
        set -g mouse on
        set -g default-shell $SHELL
        set -ga terminal-overrides ",foot:Tc"
 
 	set-option -g status-position top #

        set -g @resurrect-capture-pane-contents 'on'
        set -g @continuum-restore 'on'
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_status_background "none"
        set -g @catppuccin_window_status_style "none"
        set -g @catppuccin_pane_status_enabled "off"
        set -g @catppuccin_pane_border_status "off"

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
	
	# Go to previous window
	bind -r N switch-client -n
	bind -r P switch-client -p
	
	# Vim like pane splitting
	bind H split-window -v
	bind V split-window -h
	
	# Start windows and panes at 1 and not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on
	
	# Undercurl
	set -g default-terminal "''${TERM}"
	set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
	set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
	
	# Toggle tmux status bar
	bind '\' set status
	if-shell "[[ $(tmux lsw | wc -l) -le 1 ]]" 'set -g status'

	set -g status on

	# Configure Online status
	set -g @online_icon "ok"
	set -g @offline_icon "nok"
	
	# status left look and feel
	set -g status-left-length 100
	set -g status-left ""
	set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
	set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
	set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
	set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
	set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"
	
	# status right look and feel
	set -g status-right-length 100
	set -g status-right ""
	set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
	set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
	set -ga status-right "#[bg=#{@thm_bg}]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"
	
	# Configure Tmux
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
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    initialPassword = "031581364";
    packages = with pkgs; [
      tree
    ];
  };

  # programs.firefox.enable = true;

  # SwayFX configuration
  programs.sway = {
  	enable = true;
	package = pkgs.swayfx;
	wrapperFeatures.gtk = true;
  };

  # Login manager minimal
  # services.greetd = {
  # enable = true;
  # settings = {
  #  default_session = {
  #    commande = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  #    user = "greeter";
  #   };
  #  };
  # };

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     lazygit
     neovim
     tmux
     ghostty
     librewolf
     fuzzel
     waybar
     mako
     networkmanagerapplet
     quickshell
     qt6.qtwayland
     brightnessctl

     wl-clipboard
     grim
     swaylock
     swayidle

     claude-code

     nodejs_22
     nodePackages.npm
     nodePackages.pnpm

     gcc
     clang
     llvm
     cargo
  ];

  # Activate flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
