{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
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

    # Terminal related

    neofetch
    kitty
		hyfetch
		nerd-fonts.iosevka-term	#nerdfonts

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
	
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    })  # or just nixpkgs.nixvim if available
    )

  ];


  #---------- PROGRAMS CONFIG ----------#

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

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
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
    };
  };

  home.stateVersion = "25.05";
}
