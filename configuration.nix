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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "zswap.enabled=1" ];
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "simon-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    layout = "us";
    xkbVariant = "dvorak";
    xkbOptions = "eurosign:e";
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };

  services.gnome3.chrome-gnome-shell.enable = true;
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;

  hardware.pulseaudio.enable = false;

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

  services.tailscale.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

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
    gnome3.pomodoro
    taskwarrior
    timewarrior
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.impatience
    gnomeExtensions.workspace-matrix
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.remove-dropdown-arrows
    gnomeExtensions.taskwhisperer
    gnomeExtensions.gsconnect
    gnomeExtensions.tilingnome
    gnomeExtensions.dynamic-panel-transparency
    gnomeExtensions.window-is-ready-remover
    gnomeExtensions.freon
    gnomeExtensions.system-monitor
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  fonts.fonts = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  virtualisation.podman.enable = true;

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

  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

  # nix.package = nixpkgs.nixUnstable;
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';
  nix = {
   package = pkgs.nixFlakes;
   extraOptions = "experimental-features = nix-command flakes";
   };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

