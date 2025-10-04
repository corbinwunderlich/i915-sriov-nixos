{
  description = "NixOS module which provides a kernel and dkms module for i915 SR-IOV";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {nixpkgs, ...}: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib;
    customKernel = pkgs.callPackage ./kernel.nix {};
    i915SRIOVModule = (pkgs.linuxPackagesFor customKernel).callPackage ./i915-sriov-dkms.nix {};
  in {
    nixosModules = {
      i915-sriov = import ./default.nix {inherit pkgs lib customKernel i915SRIOVModule;};
      binary-cache = import ./binary-cache.nix;
    };

    packages.x86_64-linux = {
      default = i915SRIOVModule;
      kernel = customKernel;
    };
  };
}
