# https://github.com/Icy-Thought/Snowflake/blob/6d2e482eb1b509611ad0577eddf75784b5c4b7ab/modules/shell/fish.nix
{ pkgs, ... }:
{
  imports =
    [
      ./starship.nix
      ./tmux.nix
    ];
  users.defaultUserShell = pkgs.fish;
  home-manager.users.f3r10.programs.fish = {
    enable = true;
    shellInit = ''
      # General Configurations
        set fish_greeting
        set -gx EDITOR nvim
        set -g fish_key_bindings fish_vi_key_bindings
        # Customizable fish_title
        function fish_title
            echo $argv[1]
        end
        # Tmux on terminal start
        if status is-interactive
        and not set -q TMUX
            exec tmux
        end
      # Sources
              starship init fish | source
    '';
    shellAbbrs = {
      ls = "exa -al --color=always --group-directories-first";
      la = "exa -a --color=always --group-directories-first";
      ll = "exa -l --color=always --group-directories-first "; # long format
      lt = "exa -aT --color=always --group-directories-first"; # tree listing
    };
  };

  home-manager.users.f3r10.home.packages = with pkgs; [
    exa
    bat
  ];
}
