{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    pkgs.rustup
    pkgs.espup
    pkgs.espflash
    pkgs.laze
    pkgs.nushell
    pkgs.probe-rs-tools
  ];

  enterShell = ''
    echo RUSTC Version:
    rustc --version

    echo CARGO Version:
    cargo --version

    echo LAZE Version:
    laze --version

    echo List of connected DEBUG PROBES
    probe-rs list

    echo Info of connected DEBUG PROBES
    probe-rs info

    echo devenv for blazing-fan is ready
  '';

  languages.rust = {
    enable = true;
    lsp.enable = true;
    toolchainFile = ./rust-toolchain.toml;
  };

}
