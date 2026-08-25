class Octomon < Formula
  desc "Btop-style terminal network monitor: latency, bandwidth, and Wi-Fi signal"
  homepage "https://github.com/securitypedant/octomon"
  version "0.7.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/securitypedant/octomon/releases/download/v0.7.2/octomon-aarch64-apple-darwin.tar.xz"
    sha256 "71e0b9fdff89788583e4ac2e0c3dfc23fa35d9e3dd5aae192c2c83453f7f300f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/securitypedant/octomon/releases/download/v0.7.2/octomon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6fe535281fec3760351511a817c84f275c8a26ec695ffba7a72a24fbb60466d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/securitypedant/octomon/releases/download/v0.7.2/octomon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f2b9b27de304f6f83f67f46ff080b1dbf4cd799ed2ba693cc94c119e8d74aa5e"
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
