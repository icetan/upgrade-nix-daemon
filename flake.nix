{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      upgrade-nix-daemon = pkgs.writeShellApplication {
        name = "upgrade-nix-daemon";
        runtimeInputs = with pkgs; [ coreutils ];
        text = builtins.readFile ./upgrade-nix-daemon;
      };
      app = {
        program = "${upgrade-nix-daemon}/bin/upgrade-nix-daemon";
        type = "app";
      };
    in
    {
      packages = {
        default = upgrade-nix-daemon;
      };
      apps = {
        default = app;
      };
    });
}
