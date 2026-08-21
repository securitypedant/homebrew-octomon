class Octomon < Formula
  desc "Btop-style terminal network monitor: latency, bandwidth, and Wi-Fi signal"
  homepage "https://github.com/securitypedant/octomon"
  version "0.6.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/securitypedant/octomon/releases/download/v0.6.3/octomon-aarch64-apple-darwin.tar.xz"
    sha256 "c0a0cd03a9df6be8e202538d180165e27181ebb685402d5aa2b9e4a2ae7bc4b5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/securitypedant/octomon/releases/download/v0.6.3/octomon-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b1807ab89ddcbb022679e0bd8f60973b8574775f02a4cff20f15f12e5554ca79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/securitypedant/octomon/releases/download/v0.6.3/octomon-x86_64-unknown-linux-musl.tar.xz"
      sha256 "420d7b6c6ab327742d5f5ecc8681ead9e08e1443db5f6406b869f654b01c6668"
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
