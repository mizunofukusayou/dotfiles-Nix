{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  nix.enable = false;

  imports = [
    ./modules/env.nix

    ./system.nix
    ./keymap.nix
    ./home_manager.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
