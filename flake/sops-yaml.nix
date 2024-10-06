{ lib }:

let
  ownedKeys = [

  ];

  hosts = {

  };

  allHostKeys = lib.mapAttrsToList (_: cfg: cfg) hosts;

  mkNamedCreationRule = name: key: {
    path_regex = "^secrets/${name}(.plain)?.yaml$";
    key_groups = [ { age = lib.lists.flatten (ownedKeys ++ [ key ]); } ];
  };

  hostsCreateionRule = map (it: mkNamedCreationRule "hosts/${it.key}" it.value) (
    lib.mapAttrsToList (key: value: { inherit key value; }) hosts
  );
in
{
  creation_rules = [ ] ++ hostsCreateionRule;
}
