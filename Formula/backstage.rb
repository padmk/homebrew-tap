# Rendered by .github/workflows/release.yml into the tap as Formula/backstage.rb.
# Builds Backstage.app from the tagged source, since the app is signed on the Mac it runs on: `backstage setup`
# then installs it into Applications with this Mac's certificate, so macOS keeps its permissions across upgrades.
# Homebrew itself never writes outside its prefix or asks for a permission.
class Backstage < Formula
  desc "Let AI agents use your Mac's apps in the background"
  homepage "https://github.com/padmk/backstage"
  url "https://github.com/padmk/backstage/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8ea179da7839a4eb1057222f664a02dba5114c1ab32352ed327ae7bcc8689612"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # SwiftPM's own sandbox cannot start inside Homebrew's build sandbox.
    system "make", "app", "SWIFT_BUILD_FLAGS=--disable-sandbox"
    libexec.install "build/Backstage.app"
    bin.write_exec_script libexec/"Backstage.app/Contents/Helpers/backstage"
  end

  # Tty prints nothing when output is not a terminal or NO_COLOR is set.
  def caveats
    <<~EOS
      #{Tty.bold}#{Tty.yellow}Action needed. Run:#{Tty.reset}

          #{Tty.bold}#{Tty.green}backstage setup#{Tty.reset}

      It installs Backstage.app into Applications, signed for this Mac, asks
      you to enable it under Accessibility and registers its MCP server with
      Claude Code and Codex.

      #{Tty.bold}Run it again after every `brew upgrade backstage`; until then
      agents keep the previous version.#{Tty.reset} Running agent sessions
      then move to the new version on their next request by themselves.

      Before `brew uninstall backstage`, which leaves the copy in
      Applications, run:
          backstage uninstall
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/backstage version").strip
  end
end
