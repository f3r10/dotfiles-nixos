{ pkgs, ... }: {

  services = {
    xserver = {
      enable = true;
      layout = "pl";
      xkbVariant = "colemak";
      xkbOptions = "ctrl:nocaps";
      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
        touchpad.middleEmulation = true;
        touchpad.naturalScrolling = true;
        mouse.disableWhileTyping = true;
        mouse.naturalScrolling = true;
      };
      displayManager = {
        defaultSession = "none+myxmonad";
        sessionCommands = ''
          bluetoothctl power on
        '';
      };
      windowManager = {
        session = [{
          name = "myxmonad";
          start = ''
            /usr/bin/env f3r10-xmonad &
            waitPID=$!
          '';
        }];
      };
    };
    tlp.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdotool
    xwallpaper
    xsecurelock
    xorg.xkill
    haskellPackages.xmonad
    /* haskellPackages.f3r10-xmobar */
    haskellPackages.f3r10-xmonad
  ];
}
