{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    pkgs.espup
    pkgs.espflash
    pkgs.laze
    pkgs.nushell
  ];

  enterShell = ''
    rustc --version
    cargo --version
    laze --version
  '';

  languages.rust = {
    enable = true;
    channel = "stable";
    targets = [ "thumbv6m-none-eabi" ];
  };

}
