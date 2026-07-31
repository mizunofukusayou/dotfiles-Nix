{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      lua-language-server
    ];
  };

  xdg.configFile."nvim".source = ./config;
}
