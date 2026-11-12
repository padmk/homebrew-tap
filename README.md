# Homebrew tap

Homebrew casks and formulae for padmk's tools.

## Portside

```sh
brew install --cask padmk/tap/portside
```

[Portside](https://github.com/padmk/portside) keeps your local dev servers running, in one place: a menu bar app, a dashboard, a CLI and an MCP server for coding agents. The cask needs macOS 26 or later on Apple Silicon. Report problems in the [Portside repository](https://github.com/padmk/portside/issues).

To build the command-line tool and dashboard from source instead, without the menu bar app, use `brew install --formula padmk/tap/portside`, on macOS or Linux. Install either the cask or the formula, not both.

## Backstage

```sh
brew install padmk/tap/backstage
backstage setup
```

[Backstage](https://github.com/padmk/backstage) lets AI agents use your Mac's apps in the background, while you keep working: an MCP server and a signed helper app, with a list of the apps agents may use. The formula builds the app from source and needs macOS 26 or later on Apple Silicon and the Xcode command line tools; `backstage setup` installs it into Applications and asks for Accessibility. Run `backstage setup` again after `brew upgrade backstage`, and `backstage uninstall` before `brew uninstall backstage`. Report problems in the [Backstage repository](https://github.com/padmk/backstage/issues).

Each project's release workflow updates its own files here (`Casks/portside.rb` and `Formula/portside.rb` for Portside, `Formula/backstage.rb` for Backstage); do not edit them by hand.
