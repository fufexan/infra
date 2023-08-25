{
  inputs,
  self,
  ...
}: {
  imports = [
    {
      _module.args.shared_modules = [
        {_module.args = {inherit inputs self;};}
        inputs.agenix.nixosModules.default
        inputs.disko.nixosModules.disko
        inputs.impermanence.nixosModules.impermanence

        inputs.srvos.nixosModules.server
        ./core.nix
      ];
    }
  ];
}
