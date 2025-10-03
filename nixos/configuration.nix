{ config, pkgs, ... }:

{
  imports =
    [ # Change the impure flag
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.nameservers = [ "192.168.0.104" "1.1.1.1" ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.displayManager.ly.enable = true;

   # Enable the X11 windowing system.

  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
    #layout = "us";
    #variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Ollama -> Port to docker!

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  #hardware.alsa.defaultDevice.playback = "sofhdadsp";

  boot.extraModprobeConfig = ''
  options sof_hda_dsp model=headset-mode
  options sofhdadsp slots=sof_da_dsp
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  users.users.lilly = {
    isNormalUser = true;
    description = "Lilly Groot Wassink";
    extraGroups = [ "networkmanager" "wheel" "disk" "storage" "plugdev" ];
  };

  environment.systemPackages = with pkgs; [ # Basically just the barebones to fetch new config!
    git
    wget
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "neovim";

  # Steam
  programs.steam.enable = true;
  hardware.graphics.enable32Bit = true;

  # Automatic usage of keys
  programs.ssh.startAgent = true;
  
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  
  # Enable WireGuard

  services.devmon.enable = true;
  services.gvfs.enable = true; 
  services.udisks2.enable = true;

  system.stateVersion = "25.05";

}
