# Changelog

All notable changes to this repository are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file tracks the **platform** itself (structure, shared package, tooling,
CI), which is versioned with SemVer tags from `v1.0.0` on. The **product docs**
are versioned separately, by branch (see
[CONTRIBUTING.md](CONTRIBUTING.md#versioning--releases)) — a gwm release does
not move this number, and this number does not freeze anyone's docs.

This root file carries the current `[Unreleased]` section only; every released
version lives in its own file under [`changelogs/`](changelogs/).

## [Unreleased]

### Added

- Les alerts GFM de la doc amont (`> [!WARNING]`, `> [!TIP]`, …) rendent en
  asides Starlight, via une passe mdast déclarée dans `markdown.processor`
  ([#81](https://github.com/kbrdn1/kbrdn-docs/issues/81)). C'est la moitié site
  de [gwm-cli#641](https://github.com/kbrdn1/gwm-cli/issues/641) : GitHub rend
  les alerts GFM nativement et la syntaxe d'aside de Starlight ne rend rien
  là-bas, donc l'amont écrit la seule syntaxe native des deux côtés et le site
  la traduit au rendu. Un `**gras**` seul en tête du bloc devient le titre de
  l'aside, celui que GFM ne sait pas porter.

### Changed

- Le formatage passe de prettier à `bun fmt`, intégré à Bun 1.4.4, dans les
  scripts, la CI, le hook pre-commit et le bot `sync-gwm`
  ([#86](https://github.com/kbrdn1/kbrdn-docs/issues/86)). Il lit le
  `.prettierrc.json` existant, avec un écart nul sur l'arbre. Sur du Markdown
  neuf il est un peu plus permissif que prettier : il garde un titre setext et
  une ligne vide avant une liste imbriquée, que prettier réécrit. Les `.astro`
  ne sont pas natifs, `bun fmt` les confie au
  prettier installé avec `prettier-plugin-astro`, qui restent donc en
  devDeps. oxlint reste aussi : `bun lint` intégré n'existe pas encore en
  version stable.
- Bun 1.4.4 partout : `packageManager`, les quatre `setup-bun`, et le
  devShell Nix, qui surcharge le bun de nixpkgs (encore en 1.4.2, sans
  `bun fmt`) en attendant NixOS/nixpkgs#574334. `flake.lock` est désormais
  versionné : la révision nixpkgs fait partie du gate de format.

## Past releases

- [1.1.0](changelogs/1.1.0.md) — 2026-08-14
- [1.0.0](changelogs/1.0.0.md) — 2026-08-13
