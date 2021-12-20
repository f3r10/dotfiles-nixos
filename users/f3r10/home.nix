{ config, pkgs, ... }:

{

  #imports = (import ./programs);
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "f3r10";
  home.homeDirectory = "/home/f3r10";

  programs.git = {
   enable = true;
   userName = "f3r10";
   userEmail = "frledesma@outlook.com";
  };

  programs.gpg = {
   enable = true;
  };

  services.gpg-agent = {
   enable = true;
   pinentryFlavor = "curses";
  };

  home.packages = with pkgs; [
   alacritty
   git
   git-crypt
   gnupg
   pinentry-curses
  ];

  xsession = {
   enable = true;
   windowManager.i3 = rec {
    enable = true;
   };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
