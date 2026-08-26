class Octomon < Formula
  desc "Btop-style terminal network monitor: latency, bandwidth, and Wi-Fi signal"
  homepage "https://github.com/securitypedant/octomon"
  version "0.7.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/securitypedant/octomon/releases/download/v0.7.5/octomon-aarch64-apple-darwin.tar.xz"
    sha256 "9c00e007c0eae7d95e1fd9e4640cee06a3f124c65a64d1c148c0cb451e49aeea"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/securitypedant/octomon/releases/download/v0.7.5/octomon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1b122671997ba2da39d563edf5d8b8ae9951102cbee4d313592a4cb84db5e522"
    end
    if Hardware::CPU.intel?
      url "https://github.com/securitypedant/octomon/releases/download/v0.7.5/octomon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "22b6b8faa26d7217defcbfcf8581e8bb5bff7267ed330456b492d30acc442fdb"
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
