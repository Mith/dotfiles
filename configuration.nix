# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "zswap.enabled=1" ];
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1; # required for rr recording

  networking.hostName = "simon-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # networking.wg-quick.interfaces = {
  #   wg-mullvad = {
  #     privateKey = "9XTJw9kAESd/0QWnFmgNcb94katEP1rozpzNCTWmKXc=";
  #     address = ["10.65.135.46/32" "fc00:bbbb:bbbb:bb01::2:872d/128"];
  #     dns = ["193.138.218.74"];
  #   };
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
    earlySetup = true;
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    layout = "us";
    xkbVariant = "dvorak";
    displayManager.gdm.enable = true;
    # displayManager.sddm.enable = true;
    # displayManager.defaultSession = "sway";
    desktopManager.gnome.enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.ratbagd.enable = true;

  sound.enable = true;

  hardware.pulseaudio.enable = false;
  # hardware.pulseaudio.support32Bit = true;


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
  };
  programs.noisetorch.enable = true;

  services.tailscale.enable = true;

  # services.geoclue2.enable = true;

  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [ "a84ac5c10a9eafe2" ];
  # };

  services.flatpak.enable = true;
  services.fwupd.enable = true;
  programs.fish.enable = true;

  users.users.simon = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker"];

  };

  security.sudo.extraRules = [
    {
      users = [ "simon" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweak-tool
    taskwarrior
    timewarrior
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.impatience
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.gsconnect
    gnomeExtensions.window-is-ready-remover
    gnomeExtensions.tiling-assistant
    gnomeExtensions.just-perfection
    gnomeExtensions.pop-shell
    pavucontrol
    vulkan-loader
    piper
    podman-compose
    docker-compose
  ];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux;
  #   [ libva ]
  #   ++ lib.optionals config.services.pipewire.enable [ pipewire ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  # virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;

  programs.steam.enable = true;
  programs.corectrl.enable = true;
  # programs.gamemode.enable = true;
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  #   extraSessionCommands = ''
  #     export MOZ_ENABLE_WAYLAND=1
  #   '';
  # };

  # systemd.user.targets.sway-session = {
  #   description = "Sway compositor session";
  #   documentation = [ "man:systemd.special(7)" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };

  # xdg = {
  #   portal = {
  #     enable = true;
  #     extraPortals = with pkgs; [
  #       xdg-desktop-portal-wlr
  #       xdg-desktop-portal-gtk
  #     ];
  #     gtkUsePortal = true;
  #   };
  # };


  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedUDPPorts = [
    34197 # Factorio
  ];

  networking.firewall.allowedTCPPortRanges = [
    { from = 1714; to = 1764; } # KDE Connect
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 1714; to = 1764; } # KDE Connect
  ];
  networking.enableIPv6 = false;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/simon/src/dotfiles";
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "home-manager"
      "--update-input"
      "neovim-nightly-overlay"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

