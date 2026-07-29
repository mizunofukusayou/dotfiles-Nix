{ pkgs, lib, ... }:
let
  hexToInt = s: pkgs.lib.trivial.fromHexString s;

  mkKeyMapping = src: dst: {
    HIDKeyboardModifierMappingSrc = hexToInt src;
    HIDKeyboardModifierMappingDst = hexToInt dst;
  };

  # Key-map References:
  #   https://developer.apple.com/library/archive/technotes/tn2450/_index.html
  # e.g.
  #   07000 = Keyboard, 000E3 = Left Command
  #     -> 0x7000000E3 = Keyboard Left Command
  # macOS Fn key:
  #   https://apple.stackexchange.com/questions/340607/what-is-the-hex-id-for-fn-key%EF%BC%89
  leftCommand = "0x7000000E3";
  rightCommand = "0x7000000E7";
  capsLock = "0x700000039";
  kana = "0x700000090";
  abc = "0x700000091";
  backspace = "0x70000002A";
  rightArrow = "0x70000004F";
  option = "0x7000000E2";
  escape = "0x700000029";

  userKeyMapping = [
    # Caps Lock -> Left Command
    (mkKeyMapping capsLock leftCommand)
    # Left Command -> Esc
    (mkKeyMapping leftCommand escape)
    # ABC -> Backspace
    (mkKeyMapping abc backspace)
    # Right Command -> Option
    (mkKeyMapping rightCommand option)
    # Kana -> Right Arrow
    (mkKeyMapping kana rightArrow)
  ];

  # MacBook 本体の内蔵キーボードを特定するための条件。
  # Apple Silicon 機では内蔵キーボードの VendorID/ProductID が
  # どちらも 0x0 になり、他のデバイスとも重複してしまうため使えない。
  # 代わりに、`hidutil list` で確認できる
  # "Apple Internal Keyboard / Trackpad" の LocationID を使う。
  #
  # 注意: `hidutil list` の出力ヘッダーは "UsagePage"/"Usage" と表示されるが、
  # --matching (--filter) で実際に使えるキー名は
  # "PrimaryUsagePage" / "PrimaryUsage" (man hidutil 参照)。
  # UsagePage 1 / Usage 6 = Generic Desktop / Keyboard のエンドポイント。
  #
  # 事前に以下を実行して、自分のマシンの LocationID に書き換えること:
  #   hidutil list --matching '{"PrimaryUsagePage":1,"PrimaryUsage":6}'
  internalKeyboardLocationID = "0xE6"; # ← 要確認・要書き換え

  matching = builtins.toJSON {
    LocationID = hexToInt internalKeyboardLocationID;
    PrimaryUsagePage = 1;
    PrimaryUsage = 6;
  };

  mapping = builtins.toJSON { UserKeyMapping = userKeyMapping; };
in
{
  # 標準の system.keyboard.enableKeyMapping / userKeyMapping は、
  # 内部で `hidutil property --set ...` を --matching なしで実行するため、
  # 接続されている全キーボード(外付けも含む)に適用されてしまう。
  # そのため使用せず、--matching 付きの activation script を自前で定義する。
  system.keyboard.enableKeyMapping = false;

  system.activationScripts.postActivation.text = ''
    echo "configuring keyboard (internal keyboard only)..." >&2
    /usr/bin/hidutil property \
      --matching '${matching}' \
      --set '${mapping}' > /dev/null
  '';
}
