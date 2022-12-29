{ config, pkgs, user ? "player", ... }: {

  # XFCE4 desktop environment
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
  };
  programs.xfconf.enable = true;

  # Users
  users = {
    mutableUsers = true;
    users."${user}" = {
      uid = 1000;
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "${user}";
    };
  };

  # Pre-installed packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
  ];
}