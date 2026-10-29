{
  description = "kbrdn-docs - Development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # `bun fmt` n'existe qu'à partir de Bun 1.4.4, et nixpkgs s'arrête à
        # 1.4.2. Même dérivation, seuls la version et les binaires changent
        # (assets et hashes de SHASUMS256.txt). À retirer quand
        # NixOS/nixpkgs#574334 ou #577354 arrive sur nixos-unstable.
        bun = pkgs.bun.overrideAttrs (old: {
          version = "1.4.4";
          # Le `src` de la dérivation se calcule depuis `passthru.sources` :
          # le changer ici suffit, l'avertissement de nixpkgs ne le voit pas.
          __intentionallyOverridingVersion = true;
          passthru = old.passthru // {
            sources = builtins.mapAttrs
              (_: { asset, hash }: pkgs.fetchurl {
                url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.4/bun-${asset}.zip";
                inherit hash;
              })
              {
                aarch64-darwin = { asset = "darwin-aarch64"; hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA="; };
                aarch64-linux = { asset = "linux-aarch64"; hash = "sha256-uqa7NvUdblhWHgK76oJQOKnfRU9nPW13bou/hvjHhQ4="; };
                x86_64-linux = { asset = "linux-x64-baseline"; hash = "sha256-4ERutVmVdy65iUvrrppr42jZhai5Jx7hJEhvmUbu3XY="; };
              };
          };
        });

      in
      {
        devShells.default = pkgs.mkShell {
          name = "kbrdn-docs";

          buildInputs = with pkgs; [
            # Bun (l'override ci-dessus, pas pkgs.bun)
            bun

            # Tools
            git
            curl
            jq
          ];

          # Le shell ne fournit pas node : Bun est le seul runtime supporté,
          # tout passe par `bun run <script>`. mkShell n'isole pas le PATH,
          # donc un node installé sur la machine reste visible ; sur une
          # machine qui n'en a pas, les shims `#!/usr/bin/env node` de
          # node_modules/.bin (prettier, astro) ne s'appellent pas nus.
          shellHook = ''
            echo "🔧 kbrdn-docs dev env loaded"
            echo "   Bun $(bun --version 2>/dev/null)"
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };
      }
    );
}
