{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;  # Disable config check in sandbox

    config = rec {
      # Variables
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "fuzzel";

      # Window style
      window = {
        border = 1;
        titlebar = false;
      };

      floating = {
        border = 0;
        titlebar = false;
      };

      # Gaps
      gaps = {
        inner = 6;
        outer = 6;
      };

      # Colors
      colors = {
        focused = {
          border = "#8b5cf6";
          background = "#8b5cf6";
          text = "#ffffff";
          indicator = "#8b5cf6";
          childBorder = "#8b5cf6";
        };
        focusedInactive = {
          border = "#44475a";
          background = "#44475a";
          text = "#f8f8f2";
          indicator = "#44475a";
          childBorder = "#44475a";
        };
        unfocused = {
          border = "#282a36";
          background = "#282a36";
          text = "#bfbfbf";
          indicator = "#282a36";
          childBorder = "#282a36";
        };
        urgent = {
          border = "#ff5555";
          background = "#ff5555";
          text = "#f8f8f2";
          indicator = "#ff5555";
          childBorder = "#ff5555";
        };
      };

      # Key bindings
      keybindings = let
        mod = modifier;
        left = "h";
        down = "j";
        up = "k";
        right = "l";
      in {
        # Basics
        "${mod}+t" = "exec ${terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${menu}";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

        # Focus movement (vim keys)
        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        # Focus movement (arrow keys)
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        # Move windows (vim keys)
        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

        # Move windows (arrow keys)
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # Move to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # Layout
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";

        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";

        # Resize mode
        "${mod}+r" = "mode resize";

        # Multimedia keys
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "Print" = "exec grim";
      };

      # Resize mode
      modes = {
        resize = {
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";

          "Left" = "resize shrink width 10 px";
          "Down" = "resize grow height 10 px";
          "Up" = "resize shrink height 10 px";
          "Right" = "resize grow width 10 px";

          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      # Startup commands
      startup = [
        { command = "quickshell"; }
      ];

      # Output configuration
      output = {
        "*" = {
          bg = "${../files/wallpapers/nix_bg.png} fill";
        };
      };

      # Floating modifier
      floating.modifier = modifier;

      # Disable default swaybar (using quickshell instead)
      bars = [];
    };

    # SwayFX specific configuration
    extraConfig = ''
      # Corner radius (SwayFX feature)
      corner_radius 8

      # Blur (SwayFX feature)
      blur enable
      blur_xray disable
      blur_passes 3
      blur_radius 8
      blur_noise 0
      blur_brightness 1
      blur_contrast 1

      # Shadows (SwayFX feature)
      shadows disable
      shadows_on_csd disable
      shadow_blur_radius 20

      # Include system configs
      include /etc/sway/config.d/*
    '';
  };

  # Ensure required packages are available
  home.packages = with pkgs; [
    fuzzel
    grim
    brightnessctl
  ];
}
