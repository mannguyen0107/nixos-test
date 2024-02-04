# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  sudoUser="mannguyen";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        devices = ["nodev"];
        useOSProber = true;
	configurationLimit = 10;
      };
      # Use the systemd-boot EFI boot loader.
      # systemd-boot = {
      #   enable = true;
      # }
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 5;
    };
  };

  networking = {
    # Define your hostname.
    hostName = "nixox";
    networkmanager = {
      enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # extraLocaleSettings = {};
  };
  console = {
    font = "Lat2-Terminus16";
  #   keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      windowManager = {
        qtile = {
	  enable = true;
	  extraPackages = python3packages: with python3packages; [
	    dbus-next
	  ];
        };
      };
      # Configure keymap in X11
      xkb = {
        layout = "us";
	# options = "";
      };
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      resolutions = [
        {
          x = 1920;
	  y = 1440;
	}
      ];
    };
    # picom = {
    #   enable = true;
    # };
    # Enable CUPS to print documents.
    # printing.enable = true;
  };

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  # hardware.pulseaudio.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # hsphfpd.enable = true; # HSP & HFP daemon
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
	};
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${sudoUser} = {
    initialPassword = "123";
    isNormalUser = true;
    createHome = true;
    home = "/home/${sudoUser}";
    shell = pkgs.zsh;
    extraGroups = [ 
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "sys"
      "log"
      "floppy"
      "scanner"
      "power"
      "rfkill"
      "users"
      "video"
      "storage"
      "optical"
      "lp"
      "audio"
      "adm"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    htop
    neofetch
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
    };
  };

  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

