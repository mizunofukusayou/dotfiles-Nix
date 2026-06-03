{ config, ... }:
let
  homeDir = config.users.users.${config.myEnv.name}.home;

  apps = {
    sys = "/System/Applications";
    global = "/Applications";
    local = "${homeDir}/Applications";
    hm = "${homeDir}/Applications/Home Manager Apps";
  };
in
{
  system.primaryUser = config.myEnv.name; # Macのユーザー設定を変更する際に必要

  security.pam.services.sudo_local.touchIdAuth = true; # タッチIDでsudoを許可する

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
      AppleIconAppearanceTheme = "RegularDark"; # アイコンの外観をダークモードに設定
      # Finder
      AppleShowAllExtensions = true; # ファイル拡張子を常に表示
    };
    # Finder
    finder = {
      AppleShowAllFiles = true; # 隠しファイルを表示
      FXDefaultSearchScope = "SCcf"; # 検索範囲をカレントフォルダに設定
      ShowPathbar = true; # パスバーを表示
      _FXShowPosixPathInTitle = true; # タイトルバーにPOSIXパスを表示
      FXEnableExtensionChangeWarning = false; # ファイル拡張子変更の警告を無効化
      FXPreferredViewStyle = "clmv"; # デフォルトの表示方法をカラムビューに設定
      NewWindowTarget = "Other"; # 新しいFinderウィンドウの表示場所を`NewWindowTargetPath`に設定
      NewWindowTargetPath = "file://${homeDir}/Downloads/";
      FXRemoveOldTrashItems = true; # ゴミ箱に入れてから30日後に自動的に削除
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
        "${apps.local}/Brave Browser.app"
        "${apps.hm}/Visual Studio Code.app"
        "${apps.hm}/WezTerm.app"
        "${apps.local}/traQ.app"
      ];
      persistent-others = [
        # ドックの後半に表示する項目（仕切り線の後ろ）
        "${apps.sys}/Utilities/Activity Monitor.app"
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
      "com.apple.Spotlight" = {
        PasteboardHistoryEnabled = 1; # Spotlightのペーストボード履歴を有効化
        EnabledPreferenceRules = [
          # Spotlightの検索対象から除外する項目
          "com.apple.AppStore"
          "com.apple.iCal"
          "com.apple.shortcuts"
          "com.apple.tips"
          "com.apple.iBooksX"
          "com.apple.VoiceMemos"
          "com.apple.podcasts"
          "com.apple.mail"
          "com.apple.MobileSMS"
          "com.apple.Notes"
          "com.apple.reminders"
          "com.apple.Photos"
          "com.apple.mobilephone"
          "com.apple.AddressBook"
        ];
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
