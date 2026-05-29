{ pkgs, ... }:
{
  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping =
      let
        mkKeyMapping =
          let
            hexToInt = s: pkgs.lib.trivial.fromHexString s;
          in
          src: dst: {
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
      in
      [
        # Caps Lock -> Left Command
        (mkKeyMapping capsLock leftCommand)
        # Left Command -> ABC
        (mkKeyMapping leftCommand abc)
        # ABC -> Backspace
        (mkKeyMapping abc backspace)
        # Right Command -> Kana
        (mkKeyMapping rightCommand kana)
        # Kana -> Right Arrow
        (mkKeyMapping kana rightArrow)
      ];
  };
}
