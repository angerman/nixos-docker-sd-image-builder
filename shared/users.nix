{ ... }:
with import ../secrets.nix;
{
  users.users.root.openssh.authorizedKeys.keys = [ root-key ];
  users.users.${wheel-user-name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ wheel-user-key ];
  };
}