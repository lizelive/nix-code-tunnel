{
  description = "code-tunnel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      my-vscode = with pkgs; (vscode-with-extensions.override {
        # vscode = vscodium;
        vscodeExtensions = with vscode-extensions; [
          vadimcn.vscode-lldb
          timonwong.shellcheck
          tamasfe.even-better-toml
          serayuzgur.crates
          rust-lang.rust-analyzer
          redhat.vscode-yaml
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-containers
          ms-python.vscode-pylance
          ms-python.python
          ms-dotnettools.csharp
          ms-azuretools.vscode-docker
          mkhl.direnv
          jnoortheen.nix-ide
          james-yu.latex-workshop
          github.copilot-chat
          github.copilot
        ];
      });
      runtimeInputs = with pkgs; [
        bashInteractive

        vscode
        nano # simple text editor

        wget # download stuff
        curl # curl

        jq # json stuff
        file # file type cli tool
        tree # directory tree
        nmap # map network
        glances # system monitor

        nixfmt-rfc-style # format nix
        shfmt # format ssh
        nil # Nix Language server nixd is more powerful but requires configuration
        nix-tree # see tree of nix stuff
        nix-init # init nix project from a repo
      ];
    in
    {
      packages.x86_64-linux.default = pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = "code-tunnel";
        text = "${pkgs.vscode}/lib/vscode/bin/code-tunnel --verbose --cli-data-dir /home/lizelive/.vscode/cli tunnel service internal-run";
      };
    };
}
