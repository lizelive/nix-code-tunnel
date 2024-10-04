{ lib, pkgs, config, ... }:
with lib;                      
let
  # Shorter name to access final settings a 
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.code-tunnel;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.code-tunnel = {
    enable = mkEnableOption "Visual Studio Code Tunnel";
    cli-data-dir = mkOption {
      type = types.str;
      default = "/home/lizelive/.vscode/cli";
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    systemd.user.services.code-tunnel = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      description = "Visual Studio Code Tunnel";
      path = [ pkgs.vscode pkgs.bashInteractive pkgs.wget ];
      script = "${pkgs.vscode}/lib/vscode/bin/code-tunnel --verbose --cli-data-dir ${cfg.enable} tunnel service internal-run";
      serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 10;
      };
    };
  };
}


