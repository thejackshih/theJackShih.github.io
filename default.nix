{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/c6625cd1a34d03926de68d5acc46f160b2a34b7b.tar.gz"){}}:
pkgs.mkShell {
  packages = with pkgs; [
    git
    hugo
  ];
}
