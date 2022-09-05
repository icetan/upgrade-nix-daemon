{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { nixpkgs, ... }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    inherit (pkgs) stdenv;

    upgrade-nix-daemon = pkgs.writeShellApplication {
      name = "upgrade-nix-daemon";
      runtimeInputs = with pkgs; [ coreutils ];
      text = builtins.readFile ./upgrade-nix-daemon;
    };
    app = {
      program = "${upgrade-nix-daemon}/bin/upgrade-nix-daemon";
      type = "app";
    };
  in {
    packages.x86_64-linux = {
      default = upgrade-nix-daemon;
    };
    apps.x86_64-linux = {
      default = app;
    };
  };
}
