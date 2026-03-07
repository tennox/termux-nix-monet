# Docs: https://devenv.sh/basics/
{ pkgs, inputs, ... }:
let
  # https://devenv.sh/common-patterns/#getting-a-recent-version-of-a-package-from-nixpkgs-unstable
  pkgs-latest = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{

  languages = {
    # Docs: https://devenv.sh/languages/
    nix.enable = true;
    java = {
      enable = true;
      jdk.package = pkgs.temurin-bin-17;
    };
  };

  # Android development
  # Docs: https://devenv.sh/integrations/android/
  android = {
    enable = true;
    platforms.version = [ "34" ];
    buildTools.version = [ "34.0.0" ];
    cmdLineTools.version = "11.0";
    ndk.version = [ "26.3.11579264" ];
    # Disabled to reduce disk usage
    emulator.enable = false;
    systemImages.enable = false;
    sources.enable = false;
    abis = [ "x86_64" "arm64-v8a" ];
  };

  packages = with pkgs;
    [
      gradle

      # Search for packages: https://search.nixos.org/packages?channel=unstable&query=cowsay
      # (note: this searches on unstable channel, you might need to use pkgs-latest for some):
      #pkgs-latest.task-keeper
    ];

  scripts = { }; # Docs: https://devenv.sh/scripts/

  git-hooks.hooks = {
    # Docs: https://devenv.sh/pre-commit-hooks/
    # list of pre-configured hooks: https://devenv.sh/reference/options/#pre-commithooks
    nil.enable = true; # nix lsp
    nixpkgs-fmt.enable = true; # nix formatting
  };

  difftastic.enable =
    true; # enable semantic diffs - https://devenv.sh/integrations/difftastic/
}
