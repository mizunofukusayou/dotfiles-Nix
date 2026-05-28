{ config, ... }:
{
  programs.starship = {
    enable = true;
    configPath = "${config.xdg.configHome}/starship/starship.toml";
  };

  xdg.configFile."starship/starship.toml".source = ./starship.toml;
}
