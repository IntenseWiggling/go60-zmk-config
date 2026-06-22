{ pkgs ?  import <nixpkgs> {}
, firmware ? import ../src {}
}:

let
  config = ./.;

  go60_left  = firmware.zmk.override { board = "go60_lh"; keymap = "${config}/go60.keymap"; kconfig = "${config}/go60.conf"; };
  go60_right = firmware.zmk.override { board = "go60_rh"; keymap = "${config}/go60.keymap"; kconfig = "${config}/go60.conf"; };

  go60_left_elf = go60_left.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      find . -name 'zmk.elf' -exec cp {} $out/zmk.elf \;
    '';
  });

in (firmware.combine_uf2 go60_left go60_right "go60") // {
  inherit go60_left_elf;
}