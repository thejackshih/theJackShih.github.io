{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/0c6d8c783336a59f4c59d4a6daed6ab269c4b36.tar.gz"){}}:
pkgs.mkShell {
  packages = with pkgs; [
    git
    hugo
  ];
}
