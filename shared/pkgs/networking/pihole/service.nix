{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pihole-ftl;
  ftl = pkgs.pihole-ftl;
  stateDir = "/var/lib/pihole";
in
{
    options = {
        services.pihole-ftl = {
            enable = mkOption {
                type = types.bool;
                default = false;
                description = ''
                    Whether to run pihole-FTL
                '';
            };
            logDir = mkOption {
                type = types.path;
                default = "/var/log/pihole";
                description = ''
                    Log directory for pihole-FLT.
                '';
            };
            interface = mkOption {
                type = types.str;
                description = ''
                Network interface to run Pi-hole on.
                '';
            };

            webInterface = mkOption {
                type = types.bool;
                default = false;
                description = "Whether to enable Pi-hole's AdminLTE interface";
            };

            ipv4 = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = "IPv4 address to run Pi-hole on.";
            };

            ipv6 = mkOption {
                type = types.str;
                default = "::1";
                description = "IPv6 address to run Pi-hole on.";
            };

            dnsServer = mkOption {
                type = types.str;
                default = "1.1.1.1";
                description = "IPv4 address to run Pi-hole on.";
            };

            secDnsServer = mkOption {
                type = types.str;
                default = "8.8.8.8";
                description = "IPv6 address to run Pi-hole on.";
            };
        };
    };

    config = mkIf cfg.enable {

        services.dnsmasq.enable = false;

        networking.firewall.allowedTCPPorts = [ 53 ];
        networking.firewall.allowedUDPPorts = [ 53, 67, 547 ];

        environment.etc."pihole/pihole-FTL.conf".text = ''
        MACVENDORDB=${stateDir}/macvendor.db
        GRAVITYDB=${stateDir}/gravity.db
        DBFILE=${stateDir}/pihole-FTL.db
        '';
        environment.etc."pihole/setupVars.conf".text = ''
        PIHOLE_INTERFACE=${cfg.interface}
        IPV4_ADDRESS=${cfg.ipv4}
        IPV6_ADDRESS=${cfg.ipv6}
        PIHOLE_DNS_1=${cfg.dnsServer}
        PIHOLE_DNS_2=${cfg.secDnsServer}
        QUERY_LOGGING=true
        INSTALL_WEB_SERVER=false
        INSTALL_WEB_INTERFACE=false
        LIGHTTPD_ENABLED=false

        gravityDBfile=${stateDir}/gravity.db
        gravityTEMPfile=${stateDir}/gravity_temp.db

        BLOCKING_ENABLED=true
        '';
        environment.etc."pihole/adlists.list".text = ''
        https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
        https://mirror1.malwaredomains.com/files/justdomains
        '';

        environment.etc."pihole/dns-servers.conf".text = '''';

        users.users.pihole = {
        # uid = config.ids.uids.pihole;
            description = "pihole daemon user";
            group = "pihole";
            isSystemUser = true;
            home = stateDir;
            createHome = true;
        };
        users.groups.pihole = {};

        systemd.services.pihole-ftl = {
            description = "pihole-ftl Daemon";
            after = [ "network.target" "systemd-resolved.service" ];
            wantedBy = [ "multi-user.target" ];

            preStart = ''
                for file in /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port; do
                    if ! test -e "$file"; then
                        touch "$file"
                        chown -R pihole "$file"
                    fi
                done
                for dir in /run/pihole; do
                    if ! test -e "$dir"; then
                        mkdir -p "$dir"
                        chown -R pihole "$dir"
                    fi
                done
            '';

            serviceConfig = {
                User = "pihole";
                ExecStart = "${ftl}/bin/pihole-FTL no-daemon";
                PrivateTmp = true;
                ProtectSystem = true;
                ProtectHome = true;
                PermissionsStartOnly = true;
                CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_NICE";
                AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_NICE";
            };
        };
    };
}