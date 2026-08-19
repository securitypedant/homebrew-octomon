class Octomon < Formula
  desc "Btop-style terminal network monitor: latency, bandwidth, and Wi-Fi signal"
  homepage "https://github.com/securitypedant/octomon"
  version "0.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/securitypedant/octomon/releases/download/v0.6.0/octomon-aarch64-apple-darwin.tar.xz"
    sha256 "eb33e17c486027b64bc06ce2bae8c53497092de1af8ae5793a1f205677945228"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/securitypedant/octomon/releases/download/v0.6.0/octomon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c626b28a5f3feb682628edd98aede9ee84082f265f532fd91386af3e98dd0275"
    end
    if Hardware::CPU.intel?
      url "https://github.com/securitypedant/octomon/releases/download/v0.6.0/octomon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2710bec5feacfb77f04163d1eabc9e1bafa368e7539814e5ebbfa660544ea4dc"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "octomon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "octomon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "octomon"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
