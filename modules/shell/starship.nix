{ pkgs, ... }:
{
  home-manager.users.f3r10.programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      scan_timeout = 10;

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };

      /* battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "💀";
        display = [{
          style = "bold red";
          threshold = 15;
        }];
      }; */
    };
  };
}
