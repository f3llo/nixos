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
    pavucontrol
    gimp
    alsa-utils
    zim

    temurin-jre-bin-17
    zotero

    # Terminal related

    neofetch
    alacritty
		hyfetch
		nerd-fonts.iosevka-term	# nerdfonts

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
    dig
    tcpdump

    # Sway packages
    
    swaylock
    swaybg
    grim
    slurp

    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    })  # or just nixpkgs.nixvim if available
    )

  ];


  #---------- PROGRAMS CONFIG ----------#

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        {command = "firefox && swaybg -i ~/nixos/wallpaper.jpg"; }
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --impure --flake /home/lilly/nixos";
      backup = "rsync -avz --delete --exclude='.*' /home/lilly/Documents lilly@192.168.0.103:/home/lilly/backup"; # Find better command
    };
  };

  home.stateVersion = "25.05";
}
