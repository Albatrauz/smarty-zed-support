# Smarty extension for the Zed editor

[Smarty](https://www.smarty.net/) templating language support for [Zed](https://zed.dev),
inspired by the [VS Code extension](https://github.com/aswinkumar863/smarty-vscode-support).

## Features

- **Syntax highlighting** for Smarty tags, variables, modifiers, function calls,
  operators and control-flow constructs (`{if}`/`{elseif}`/`{else}`, `{foreach}`,
  `{for}`, `{while}`, `{section}`, `{literal}`, `{block}`, …).
- **HTML / CSS / JavaScript injection** — the text around Smarty tags is parsed as
  HTML, which in turn highlights embedded `<style>` and `<script>` blocks.
- **Snippets** for ~50 common Smarty tags.
- **Bracket matching** for tag pairs (`{if}`…`{/if}`) and expression brackets.
- **Auto-indentation** of block bodies and **comment toggling** (`{* … *}`).
- **Language server** (optional, enabled by default): tag/modifier/variable
  completions, `{include}` path navigation and XSS diagnostics, via
  [`vscode-smarty-langserver-extracted`](https://www.npmjs.com/package/vscode-smarty-langserver-extracted).
  It runs on the Node runtime bundled with Zed and **does not require PHP**.

## How it works

| Concern              | Source                                                                                  |
| -------------------- | --------------------------------------------------------------------------------------- |
| Grammar              | [`Albatrauz/tree-sitter-smarty`](https://github.com/Albatrauz/tree-sitter-smarty) — a fork of [`hex-cat-man/tree-sitter-smarty`](https://github.com/hex-cat-man/tree-sitter-smarty) that adds the `&&` / `\|\|` operators. |
| Language server      | `vscode-smarty-langserver-extracted` (installed automatically into the extension dir on first use). |
| Highlighting / indent / brackets / outline | Tree-sitter queries in [`languages/smarty/`](languages/smarty). |

The grammar is fetched and compiled by Zed from its own repository, so it is not
vendored here.

## Installing

1. Clone this repository.
2. Open the Extensions panel in Zed.
3. Click **Install Dev Extension** (top-right) and select the cloned folder.
4. Open a `.tpl` file and confirm the language selector (bottom-right) shows **Smarty**.

The language server downloads on first use, so the initial open of a `.tpl` file
needs network access.

## Troubleshooting

If Zed shows `Failed to install dev extension: failed to compile grammar 'smarty'`:

1. Update Zed to the latest stable release.
2. Ensure `git` is installed and can reach GitHub.
3. Remove stale build artifacts and retry:
   - macOS: `rm -rf ~/Library/Application\ Support/Zed/extensions/build`
4. Re-open Zed and install the dev extension again.

> Built with the help of Claude Code. Use at your own risk.
