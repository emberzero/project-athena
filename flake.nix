{
  description = "typst environment";
  nixConfig.bash-prompt = "\[typst\]$ ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  } @ inputs:
    utils.lib.eachDefaultSystem (
      system: let
        p = import nixpkgs {inherit system;};
        fonts = with p; [
          fira
        ];
        fontPaths = (builtins.map (x: x + "/share/fonts/opentype") fonts) ++ (builtins.map (x: x + "/share/fonts/truetype") fonts) ++ [./athena-fonts/fonts];
        fontParam = p.lib.concatStringsSep ":" fontPaths;
        typstPackagesCache = p.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = "${inputs.typst-packages}/packages";
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
          '';
        };
        derivation = {stdenvNoCC, ...}:
          stdenvNoCC.mkDerivation {
            name = "typst-build";
            src = ./.;
            buildInputs = [p.typst] ++ fonts;
            buildPhase = ''
              echo "Current directory contents:"
              ls -la
              mkdir -p out
              export HOME=$(mktemp -d)
              export XDG_CACHE_HOME=${typstPackagesCache}
              export TYPST_FONT_PATHS=${fontParam}

              find Curriculum -type f -path "*/slides/*.typ" | while read file; do
                name=$(basename "$file" .typ)
                echo "Compiling $file → $name.pdf"
                typst compile "$file" "out/$name.pdf" --root .
              done

              # Lectures: one shared template, rendered once per Markdown file.
              find Curriculum -type f -path "*/lectures/*.md" | while read file; do
                name=$(basename "$file" .md)
                module=$(echo "$file" | sed -E 's|Curriculum/(Module [0-9]+).*|\1|' | tr -d ' ')
                echo "Compiling $file → ''${module}_''${name}.pdf"
                typst compile utils/lecture-template.typ \
                  "out/''${module}_''${name}.pdf" --root . --input md="$file"
              done
            '';

            installPhase = ''
              mkdir -p $out
              cp out/*.pdf $out/
            '';
          };
      in {
        devShell = p.mkShell.override {stdenv = p.stdenv;} rec {
          packages = with p;
            [
              typst
              tinymist
              typst-live
            ]
            ++ fonts;

          shellHook = ''
            export TYPST_FONT_PATHS=${fontParam}
          '';

          name = "Typst build";
        };
        packages = {
          default = p.callPackage derivation {};
        };
      }
    );
}
