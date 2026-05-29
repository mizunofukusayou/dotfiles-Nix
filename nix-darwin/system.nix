{ ... }:
let
  user = "mizunofukusayou";
  homeDir = "/Users/${user}";
  hmApps = "${homeDir}/Applications/Home Manager Apps";
in
{
  # Macのユーザー設定を変更する際に必要
  system.primaryUser = "${user}";

  # タッチIDでsudoを許可する
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      # マウス/トラックパッド
      "com.apple.swipescrolldirection" = true; # ナチュラルスクロールを有効化
      "com.apple.trackpad.scaling" = 3.0; # トラックパッドのカーソル速度を設定(1.0~3.0)
      # キーボード
      NSAutomaticCapitalizationEnabled = false; # 文頭の自動大文字化を無効化
      NSAutomaticPeriodSubstitutionEnabled = false; # ピリオドの自動置換を無効化
      NSAutomaticDashSubstitutionEnabled = false; # ダッシュの自動置換を無効化
      NSAutomaticQuoteSubstitutionEnabled = false; # クォートの自動置換を無効化
      InitialKeyRepeat = 20; # リピートが開始されるまでの時間
      KeyRepeat = 2; # キーリピートの速度
      ApplePressAndHoldEnabled = false; # 長押しでポップアップを出さずにリピート
      "com.apple.keyboard.fnState" = true; # F1-F12キーをファンクションキーとして使用
      # UI
      AppleInterfaceStyle = "Dark"; # ダークモードを有効化
    };
    # Finder
    finder = {
      AppleShowAllExtensions = true; # ファイル拡張子を常に表示
      AppleShowAllFiles = true; # 隠しファイルを表示
      FXDefaultSearchScope = "SCcf"; # 検索範囲をカレントフォルダに設定
      ShowPathbar = true; # パスバーを表示
      FXEnableExtensionChangeWarning = false; # ファイル拡張子変更の警告を無効化
      FXPreferredViewStyle = "clmv"; # デフォルトの表示方法をカラムビューに設定
    };
    # Dock
    dock = {
      orientation = "left"; # ドックの位置を左に設定
      show-recents = false; # 最近使ったアプリを非表示
      tilesize = 64; # ドックのサイズを設定
      magnification = true; # ドックの拡大を有効化
      largesize = 128; # ドックの拡大サイズを設定
      minimize-to-application = true; # ウィンドウをアプリケーションアイコンに格納
      persistent-apps = [
        # ドックに常に表示するアプリ
        "${hmApps}/Brave Browser.app"
        "${hmApps}/Visual Studio Code.app"
        "${hmApps}/WezTerm.app"
      ];
    };
    # 画面キャプチャ
    screencapture = {
      type = "jpg"; # ファイル形式をjpgに設定
      target = "clipboard"; # スクリーンショットの保存先をクリップボードに設定
    };
    # トラックパッド
    trackpad = {
      Clicking = true; # タップでクリックを有効化
      Dragging = true; # ドラッグを有効化
      FirstClickThreshold = 0; # クリックの固さを設定
    };
    # その他
    CustomUserPreferences = {
      NSGlobalDomain = {
        # メニューバー
        AppleMenuBarVisibleInFullscreen = 1; # フルスクリーン時にメニューバーを表示
        AutoHideMenuBarOption = 3; # メニューバーの自動非表示をしない
      };
    };
  };

  # 電源設定
  power.sleep.allowSleepByPowerButton = false; # 電源ボタンでスリープを無効化
  system.activationScripts.postActivation.text = ''
    # バッテリー駆動時(-b)のディスプレイオフを設定
    /usr/bin/pmset -b displaysleep 20

    # 電源アダプタ接続時(-c)のディスプレイオフを設定
    /usr/bin/pmset -c displaysleep 20
  '';
}
