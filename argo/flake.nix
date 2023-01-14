{
  inputs = {
    parent = { url = "path:./.."; };
    
    nixpkgs = { url = "nixpkgs/nixos-unstable";  follows = "parent/nixpkgs"; };
  };
  
  outputs = { parent, nixpkgs, ... }: let
    system   = "x86_64-linux";
    packages = nixpkgs.legacyPackages.${ system };
    parentPackages = parent.packages.${ system };
    customPackages = { inherit (packages) argocd; };
  in {
    packages.${ system } = customPackages;
    devShells.${ system }.default = packages.mkShell {
      buildInputs = with customPackages; [
        parentPackages.awscli2
        argocd
      ];
    };
  };
}
