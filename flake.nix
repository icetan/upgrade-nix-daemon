{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { nixpkgs, ... }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    inherit (pkgs) stdenv;

    upgrade-nix = pkgs.writeShellApplication {
      name = "upgrade-nix";
      runtimeInputs = with pkgs; [ coreutils nix ];
      text = builtins.readFile ./upgrade-nix;
    };
    app = {
      program = "${upgrade-nix}/bin/upgrade-nix";
      type = "app";
    };
  in {
    apps.x86_64-linux = {
      default = app;
      upgrade-nix = app;
    };
  };
}
