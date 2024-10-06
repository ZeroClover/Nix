{ lib }:

let
  ownedKeys = [
    "age1l3vzu8kt7yka23zk5w095ygfwvwcuvdhhp0arql3t2mxt8rgp9yspcqx9q"
  ];

  hosts = {
    nixos-hq = "age1dtjxakfdatagze3kjna4nx20f3d8ehwgn4v3t9jvqmfvenq8gvfsg7vpsk";
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
  creation_rules = [
    (mkNamedCreationRule "openvscode-server" [
      hosts.nixos-hq
    ])
  ] ++ hostsCreateionRule;
}
