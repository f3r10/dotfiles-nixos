let colors = import ../theme/colors.nix;
in
{
  home-manager.users.f3r10.programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;
      opacity = 1;
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        decorations = "none";
        dynamic_title = true;
        dimensions = {
          columns = 0;
          lines = 0;
        };

        position = {
          x = 50;
          y = 50;
        };

        dynamic_padding = false;
      };

      scrolling = {
        history = 50000;
        multiplier = 3;
      };

      font = {
        size = 13.0;
        normal.family = "Source Code Pro";
        bold.family = "Source Code Pro";
        bold.style = "Bold";
        italic.family = "Source Code Pro";
        italic.style = "Italic";
        bold_italic.family = "Source Code Pro";
        bold_italic.style = "Bold Italic";
        offset = {
          x = 0;
          y = 0;
        };

        glyph_offset = {
          x = 0;
          y = 0;
        };

        use_thin_strokes = true;

      };
      cursor = {
        style = {
          shape = "Block";
          blinking = "Off";
        };
        text = "CellBackground";
        cursor = "CellForeground";
      };

      selection = {
        text = "CellForeground";
        background = "#3e4452";
      };
      selection.semantic_escape_chars = '',│`| = "' ()[]{}<>'';

      draw_bold_text_with_bright_colors = true;

      colors = {
        primary = {
          background = colors.background;
          foreground = colors.foreground;
        };
        normal = {
          black = colors.black;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.magenta;
          cyan = colors.cyan;
          white = colors.white;
        };
        bright = {
          black = colors.bright-black;
          red = colors.bright-red;
          green = colors.bright-green;
          yellow = colors.bright-yellow;
          blue = colors.bright-blue;
          magenta = colors.bright-magenta;
          cyan = colors.bright-cyan;
          white = colors.bright-white;
        };
      };
      mouse.hide_when_typing = true;
      key_bindings = [
        {
          key = "V";
          mods = "Alt";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Alt";
          action = "Copy";
        }
      ];
    };
  };
}
