{
  description = "Compute Blade Smart Fan software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        rec {
          blazing-fan-daemon = pkgs.rustPlatform.buildRustPackage {
            pname = "blazing-fan-daemon";
            version = "0.1.0";

            # The workspace root is required because blazing-fan-daemon
            # depends on the local blazing-fan-proto crate.
            src = pkgs.lib.cleanSource ./.;

            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            # Build and test only the daemon package, not the TUI.
            cargoBuildFlags = [
              "--package"
              "blazing-fan-daemon"
            ];

            cargoTestFlags = [
              "--package"
              "blazing-fan-daemon"
            ];

            strictDeps = true;

            meta = {
              description = "Compute Blade Smart Fan control and telemetry daemon";
              homepage = "https://github.com/thatwhichisdev/blazing-fan";
              license = pkgs.lib.licenses.mit;
              mainProgram = "blazing-fan-daemon";
              platforms = pkgs.lib.platforms.linux;
            };
          };

          default = blazing-fan-daemon;
        }
      );

      # Optional, but useful for consumers that prefer an overlay.
      overlays.default = final: _previous: {
        blazing-fan-daemon = self.packages.${final.stdenv.hostPlatform.system}.blazing-fan-daemon;
      };

      nixosModules = {
        blazing-fan-daemon = import ./nix/module.nix {
          inherit self;
        };

        default = self.nixosModules.blazing-fan-daemon;
      };

      checks = forAllSystems (system: {
        blazing-fan-daemon = self.packages.${system}.blazing-fan-daemon;
      });
    };
}
