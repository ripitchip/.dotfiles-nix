{
  description = "Thomas's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Encrypted secrets in secrets/secrets.yaml (modules/nixos/secrets.nix)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonora = {
      url = "github:sonorahq/sonora";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Official Claude Desktop .deb, packaged for Nix (modules/home/claude-desktop.nix)
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not in nixpkgs: community flakes repackaging the upstream releases
    # (modules/home/zen-browser.nix, modules/home/helium.nix)
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      # One configuration per directory in hosts/
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/${name} ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [
        "laptop"
        "desktop"
      ] mkHost;

      # `nix fmt` formats every .nix file in the repo
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
