# Rendered by .github/workflows/release.yml into the tap as Formula/bruse.rb.
# Installs the `bruse` command with the extension and MCP server files from
# the tagged source; `bruse setup` then copies them to a stable per-user
# location that the browser and the agents use.
class Bruse < Formula
  desc "Background control of your real browser for local AI agents"
  homepage "https://github.com/padmk/bruse"
  url "https://github.com/padmk/bruse/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "cd1ac87c0c03a9c023e17b3b2e669b82675c15be99c5a0d450a17a68c8f4dad6"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "bin", "browser", "installer", "package.json"
    node = formula_opt_bin("node")/"node"
    # INSTALL_NODE is the Node.js that setup registers for the MCP server:
    # the opt path stays valid across `brew upgrade node`.
    (bin/"bruse").write <<~SH
      #!/bin/bash
      export INSTALL_NODE="${INSTALL_NODE:-#{node}}"
      exec "#{node}" "#{libexec}/bin/bruse.mjs" "$@"
    SH
  end

  def caveats
    <<~EOS
      To install the browser extension and register the MCP server with
      your agent clients (Claude Code, Codex, Cursor, VS Code and others), run:
        bruse setup
      The first time, it asks you to load the extension in your browser.
      After `brew upgrade bruse`, run `bruse setup` again.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bruse version")
  end
end
