{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  nix.enable = false;

  # タッチIDでsudoを許可する
  security.pam.services.sudo_local.touchIdAuth = true;
}
