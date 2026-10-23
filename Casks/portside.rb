# Rendered by .github/workflows/release.yml into the tap as Casks/portside.rb.
cask "portside" do
  version "0.1.0"
  sha256 "00fcb719b3a163761edaf3789d1fb7e675200bc1812e61baa4f6dd54c85c580e"

  url "https://github.com/padmk/portside/releases/download/v#{version}/Portside-#{version}.zip"
  name "Portside"
  desc "Keep your local dev servers running, in one place"
  homepage "https://github.com/padmk/portside"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Portside.app"
  binary "#{appdir}/Portside.app/Contents/Helpers/portside"

  # The app is not notarized yet; without this Gatekeeper blocks the first launch.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Portside.app"]
  end

  # Upgrades run this too, so it leaves the daemon and its servers running.
  uninstall quit: "app.foreverbeta.portside.app"

  # The bundled binary is already removed when this runs, so the login
  # service is removed and the user's other daemon processes get SIGTERM,
  # which stops their servers within their stop timeouts. The script waits
  # until they are gone and fails otherwise, so config and state are trashed
  # only once no daemon uses them.
  zap launchctl: "app.foreverbeta.portside",
      script:    {
        executable: "/bin/sh",
        args:       [
          "-c",
          'u=$(id -u); pkill -TERM -U "$u" -x portside; i=0; ' \
          'while pgrep -U "$u" -x portside >/dev/null; do ' \
          '[ $i -ge 600 ] && { echo "portside is still stopping its servers after 10 minutes; ' \
          "check with: pgrep -lU $u -x portside; when it has exited, " \
          'run brew uninstall --zap --cask portside again" >&2; exit 1; }; ' \
          "sleep 1; i=$((i+1)); done",
        ],
      },
      trash:     [
        "~/.config/portside",
        "~/.local/state/portside",
        "~/Library/Preferences/app.foreverbeta.portside.app.plist",
      ]

  caveats <<~EOS
    To connect coding agents (Claude Code, Codex, Gemini CLI), run:
      portside setup

    Uninstalling or upgrading leaves the daemon and its dev servers running.
    Before `brew uninstall --cask portside`, stop them with:
      portside daemon stop
    and, if you installed the login service:
      portside service uninstall
    `brew uninstall --zap --cask portside` stops them and also trashes the
    config and state.
  EOS
end
