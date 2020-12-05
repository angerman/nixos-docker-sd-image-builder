{
    pihole  = { imports = [ ./rpi3-node/configuration.nix ]; };
    rasp4-1 = { imports = [ ./rpi4-node/configuration.nix ]; };
    rasp4-2 = { imports = [ ./rpi4-node/configuration.nix ]; };
}