{ pkgs, ... }:
{
  home.packages = [ pkgs.ghq ];
  programs.git.settings = {
    ghq.root = "~/dev"; # ghqのルートディレクトリを指定
    url."git@github.com:".insteadOf = "https://github.com/"; # ssh経由でクローンするための設定
  };
}
