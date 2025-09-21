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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

	# Enable i3wm

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
  };

  users.users.lilly = {
    isNormalUser = true;
    description = "Lilly Groot Wassink";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #thunderbird
      #libreoffice
		  #gnome-tweaks
    ];
  };

  environment.systemPackages = with pkgs; [ # Basically just the barebones to fetch new config!
    git
    wget
  ];

  # Install firefox.
  programs.firefox.enable = true;
	programs.niri.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set the default editor to vim
  environment.variables.EDITOR = "neovim";

  # Enable docker
  #virtualisation.docker.enable = false;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Steam
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;

  system.stateVersion = "25.05";

}
