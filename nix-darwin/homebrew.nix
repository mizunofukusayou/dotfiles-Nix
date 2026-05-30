{ config, nix-homebrew, ... }:
{
  nix-homebrew = {
    enable = true;
    user = config.myEnv.name;
  };

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = false;
      cleanup = "zap";
    };
    global.autoUpdate = false;

    casks = [
      "logi-options+"
    ];
  };
}
