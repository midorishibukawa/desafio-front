{
  description = "bun development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
      devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
            chromium
            yarn
            yarn2nix
        ] ++ (with pkgs.nodePackages; [
            typescript-language-server
        ]);
      };

      shellHook = ''
        export CHROME_BIN="which chromium"
      '';
    });
  };
}
