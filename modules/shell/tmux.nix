{ config, pkgs,lib, ... }:
with lib;
let 
  tat = pkgs.writeShellScriptBin "tat" (builtins.readFile ./tat);
  td = pkgs.writeShellScriptBin "td" (builtins.readFile ./td);
  tmuxMenuSeperator = "''";
  # cfg = config.modules.terminal;
  mainWorkspaceDir = "$HOME";
  secondaryWorkspaceDir = "$HOME";
in
{

  home-manager.users.f3r10.home.packages = with pkgs; [
    pipes-rs
    tat
    td
  ];

  home-manager.users.f3r10.programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    enable = true;
    terminal = "screen-256color";
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    shortcut = "a";
    extraConfig = ''
      set -g mouse on
      bind v split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'
      bind-key R source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display-message "$XDG_CONFIG_HOME/tmux/tmux.conf reloaded"
      bind J display-popup -E "\
                 tmux list-panes -a -F '#{?session_attached,,#S:#I.#P}' |\
                 sed '/^$/d' |\
                 fzf --reverse --header join-pane --preview 'tmux capture-pane -pt {}'  |\
                 xargs tmux join-pane -v -s"
      set-option -g renumber-windows on
# keep this at the bottom
            bind-key Tab display-menu -T "#[align=centre]Sessions" "Switch" . 'choose-session -Zw' Last l "switch-client -l" ${tmuxMenuSeperator} \
              "Open Main Workspace" m "display-popup -E \" td ${mainWorkspaceDir} \"" "Open Sec Workspace" s "display-popup -E \" td ${secondaryWorkspaceDir} \""   ${tmuxMenuSeperator} \
              "Kill Current Session" k "run-shell 'tmux switch-client -n \; tmux kill-session -t #{session_name}'"  "Kill Other Sessions" o "display-popup -E \"tkill \"" ${tmuxMenuSeperator} \
              Random r "run-shell 'tat random'" Emacs e "run-shell 'temacs'" ${tmuxMenuSeperator} \
              Exit q detach"
    '';
  };
}
