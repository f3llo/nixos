{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  home.username = "lilly";
  home.homeDirectory = "/home/lilly";

  home.packages = with pkgs; [ # i3 installed differently
    # Regular packages

    rpi-imager # Replace
		audacity
    zoom-us # Nederlands
    anki
    thunderbird
    libreoffice
    gnome-tweaks
    pavucontrol
    gimp
    alsa-utils

    # Screenshot

    grim
    slurp

    # IRC Chat

    soju # Bouncer
    hexchat # IRC client

    # Terminal related

    neofetch
    kitty
    alacritty
		hyfetch
		nerd-fonts.iosevka-term	# nerdfonts
    #nerd-fonts-symbols-only # Symbols
    ranger # File manager
    swaylock

    # Privacy

    tor
    tor-browser
    searxng

		hunspellDicts.nl_nl

		# Please fix dev enviornment!
		python3
		haskell.compiler.native-bignum.ghcHEAD
    dockerfile-language-server

		legcord # Discord alternative
    cemu
    shattered-pixel-dungeon
    spotify-player
    #steam-unwrapped # Pirate stuff
    lutris

    zip
    xz
    ripgrep # recursively searches directories for a regex pattern
    fzf # A command-line fuzzy finder
		feh
		tree # Map out directories
    
    # Networking
  
    nmap
    netcat
    wireguard-tools
    traceroute

    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    })  # or just nixpkgs.nixvim if available
    )

  ];


  #---------- PROGRAMS CONFIG ----------#

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Lilly Groot Wassink";
    userEmail = "floris-groot_wassink@outlook.com";
  };

  # configure nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    colorschemes.catppuccin.enable = true;
    opts = {
      number = true;
      relativenumber = true;
			expandtab = true; # Tabulars are converted to spaces (Haskell)
      tabstop = 2;
      shiftwidth = 2;
    };
		
		plugins = {
			lualine.enable = true;
			autoclose.enable = true;
			lsp.enable = true;
		};
  	# Configure and modularize
	};

  # Install firefox 
  programs.firefox.enable = true;

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.9";
      background_blur = 5;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --impure --flake /home/lilly/nixos";
      backup = "rsync -avz --delete --exclude='.*' /home/lilly/Documents lilly@192.168.0.103:/home/lilly/backup"; # Find better command
    };
  };

  home.stateVersion = "25.05";
}
