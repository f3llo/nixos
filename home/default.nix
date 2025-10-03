{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  home.username = "matthijs";
  home.homeDirectory = "/home/matthijs";

  #---------- INSTALLED PACKAGES ----------#

  home.packages = with pkgs; [
    # Applications

		audacity # Sound
    thunderbird # Email
    libreoffice # Word proccessing suite
    gimp # GNU image manipulation
    alsa-utils # Sound -> Alsamixer
    zim # Notebook
    spotify-player # Terminal based spotify

    # Terminal related

    neofetch # Run it and try ;)
    alacritty # Terminal emulator
		nerd-fonts.iosevka-term	# Special fonts e.g. Symbols

    # Programming

		python3 # Just in case (many deps)

    # General terminal utilities

    zip # Zips files
    xz # Another comporession format
    ripgrep # recursively searches directories for a regex pattern
    fzf # A command-line fuzzy finder
		feh # Image display
		tree # Map out directories
    
    # Networking -> Mostly for troubleshooting
  
    netcat
    traceroute
    dig
    tcpdump

    # Sway packages
    
    swaylock # Lock screen
    swaybg # Set background
    grim # screenshot
    mako # Notifications

    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    })  # or just nixpkgs.nixvim if available
    )

  ];

  #---------- WINDOW MANAGER CONFIG ----------#

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";

      config = {
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        {
          "${mod}+Shift+s" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+l" = "exec --no-startup-id swaylock";
        }
      ];
      terminal = "alacritty";
      startup = [
        # Launch Firefox on start
        {command = "firefox && swaybg -i ~/nixos/wallpaper.jpg"; }
      ];
    };
    systemd.enable = true;
  };

  #---------- PROGRAMS CONFIG ----------#

  # Install firefox 
  programs.firefox.enable = true;

  # Github configuration
  programs.git = {
    enable = true;
    userName = "Matthijs Groot Wassink";
    userEmail = "m.b.grootwassink@gmail.com";
  };

  # Config nixvim (nix neovim distribution)
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
			lsp.enable = true; # Not working yet
		};
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


  # Zsh configuration, better bash
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = "zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = { # Test, backup command can be created if desired
      nix-rebuild = "sudo nixos-rebuild switch --flake .#lilly";
      hm-rebuild = "home-manager switch --flake .#main@lilly";
      hm-update = "nix flake update && home-manager switch --flake .#main@lilly";
      hm-clean = "nix-collect-garbage -d";
    };
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
    ];
  };

  systemd.user.startServices = "sd-switch"; # Restart system units
  home.stateVersion = "25.05";
}
