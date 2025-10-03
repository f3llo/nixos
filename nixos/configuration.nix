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

  networking.hostName = "nixos-thinkpad"; # Define your hostname.

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Clean system
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  users.users.greeter = {};


  # Enable the X11 windowing system -> Als je een normale GUI wilt!

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

  # Enable sound with pipewire. I have extra options because of card issues, you may not need them!
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

  boot.extraModprobeConfig = ''
  options sof_hda_dsp model=headset-mode
  options sofhdadsp slots=sof_da_dsp
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  users.users.matthijs = {
    isNormalUser = true;
    initialPassword = "default";
    description = "Matthijs Groot Wassink";
    extraGroups = [ "networkmanager" "wheel" "disk" "storage" "plugdev" ];
  };

  environment.systemPackages = with pkgs; [ # Basically just the barebones to fetch new config!
    git
    wget
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "neovim";

  # Automatic usage of keys
  programs.ssh.startAgent = true;
  
  services.devmon.enable = true;
  services.gvfs.enable = true; 
  services.udisks2.enable = true;

  system.stateVersion = "25.05";

}
