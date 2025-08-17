# NixOS System Configuration
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # === System Information ===
  system.stateVersion = "25.05"; # Did you read the comment?

  # === Boot Configuration ===
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # === Networking ===
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    resolvconf.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # === Time & Localization ===
  time.timeZone = "UTC";

  # === User Management ===
  users.users.q = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "a";
  };

  # === Desktop Environment ===
  programs.hyprland.enable = true;

  # === System Packages ===
  environment.systemPackages = with pkgs; [
    # Wayland/Display
    hyprland
    xwayland
    
    # Terminal & Basic Tools
    foot
    git
    micro
    wl-clipboard
    kakoune
    
    # Applications
    librewolf
    btop
  ];

  # === Services ===
  services = {
    chrony.enable = true;
    
    # Hardware configuration
    udev.extraHwdb = ''
      evdev:input:b*
        KEYBOARD_KEY_3a=leftctrl
        KEYBOARD_KEY_1d=capslock
    '';
  };

  # === Fonts ===
  fonts = {
    packages = with pkgs; [
      ubuntu_font_family  # Includes Ubuntu Mono
    ];
    
    fontconfig = {
      enable = true;
      antialias = false;  # Disable system-wide antialiasing
      
      defaultFonts = {
        monospace = [ "Ubuntu Mono" ];
        sansSerif = [ "Ubuntu Mono" ];
        serif = [ "Ubuntu Mono" ];
      };
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      shared = {
        path = "/home/q/shared";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "q";
      };
    };
  };
}
