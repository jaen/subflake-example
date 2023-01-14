{
  inputs = {
    nixpkgs = { url = "nixpkgs/nixos-unstable"; };

    aws = { url = "path:./aws"; };
    argo = { url = "path:./argo"; };
  };

  outputs = { nixpkgs, aws, argo, ... }: let
    system   = "x86_64-linux";
    packages = nixpkgs.legacyPackages.${ system };
    customPackages = {
      inherit (packages) dive;
      inherit (aws.packages.${ system }) awscli2;
      inherit (argo.packages.${ system }) argocd;
    };
  in {
    packages.${ system } = customPackages;
    devShells.${ system }.default = packages.mkShell {
      buildInputs = with customPackages; [
        dive
        argocd
        awscli2
      ];
    };
  };
}
