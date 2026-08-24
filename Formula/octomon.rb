class Octomon < Formula
  desc "Btop-style terminal network monitor: latency, bandwidth, and Wi-Fi signal"
  homepage "https://github.com/securitypedant/octomon"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/securitypedant/octomon/releases/download/v0.7.0/octomon-aarch64-apple-darwin.tar.xz"
    sha256 "e385bcbc66e797e6596dd0ba2f2b1777abda7c1de7b4fb631a18ea3057576939"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/securitypedant/octomon/releases/download/v0.7.0/octomon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "19f57fde2280550d4e315a3f0403d59903e09af11d65549849527de3e81b261d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/securitypedant/octomon/releases/download/v0.7.0/octomon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "26c93791bbb5d7a4f95544b69c31b468d730c44c0193f59278145d7a39de2611"
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
