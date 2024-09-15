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
        inputs.srvos.nixosModules.server
        ./core.nix
      ];
    }
  ];
}
