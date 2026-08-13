{ pkgs, ... }:
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

  # Product 名で内蔵キーボードを指定。
  matching = builtins.toJSON {
    Product = "Apple Internal Keyboard / Trackpad";
    PrimaryUsagePage = 1;
    PrimaryUsage = 6;
  };

  mapping = builtins.toJSON { UserKeyMapping = userKeyMapping; };
in
{
  system.keyboard.enableKeyMapping = false;

  system.activationScripts.postActivation.text = ''
    echo "configuring keyboard (internal keyboard only)..." >&2
    /usr/bin/hidutil property \
      --matching '${matching}' \
      --set '${mapping}' > /dev/null
  '';
}
