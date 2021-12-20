{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      displayManager = {
        defaultSession = "none+xmonad";
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };
}
