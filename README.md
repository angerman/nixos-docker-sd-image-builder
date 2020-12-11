# NixOS on SBCs

This is a collection of SBCs for which I build (mostly sd card) images.  The different
scbs are in their respective `-node` folder.  They contain `sd-image.nix` files that
can be used to build bootable images.  Do note that you will want to adjust the `secrets.nix`
based on the `secrets.nix.sample` to contain your ssh keys if you intend to do a headless
setup.

## Node management with NixOps

The `shell.nix` will allow you to drop into a nix-shell, with nixops inside.

Create something similar to the `*-node-{config,physical}.nix` that matches your setup. And then run
```
nixops create my-node-config.nix my-node-physical.nix
```
this will return a deployment uuid. (`nixops list` will also). With that run
```
nixops deploy -d <uuid>
```
and your new configuration will be deployed.

# Nodes

## Raspberry Pi 3/4
These are mostly stock nodes from nixpkgs upstream.

## RockPi4
This is the radxa rockpi4. A RK3399 with 4GB of ram, and PoE capability.  It also
has an m2 connector for a SSD and comes with emmc on board (you can write the
image directly onto the emmc)

## odroid-n2-node
The odroid-n2 is powerd by Amlogics S922X, a pretty powerful (for an scb) chip,
with 4GB ram. There is also the n2+ which should work as well. They lack wireless
but have the same emmc as the RockPi4, and in fact the modules are compatible.

## Helios64
The Helios64 from kobol.io is an open source NAS. Similar to the RockPi4 it's a
RK3399 chip with 4GB of ram, but comes with 5 SATA connectors, 16GB of onboard
emmc, ... The kobol.io team contributes to the armbian project and as such the
Helios64 is best supported in armbian.  The NixOS image therefore takes the
armbian kernel (upstream kernel + armbian patches and configuration), as well
as the bsp packages from arbian and integrates them.
