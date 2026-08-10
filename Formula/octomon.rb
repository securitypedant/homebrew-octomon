class Octomon < Formula
  desc "A btop-style terminal dashboard for network performance: latency, bandwidth, per-process usage, and Wi-Fi signal."
  homepage "https://github.com/securitypedant/octomon"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/securitypedant/octomon/releases/download/v0.1.1/octomon-aarch64-apple-darwin.tar.xz"
    sha256 "904220e852ae4c2195ff527257d1acce38dd7158e16858964825fd78a817201c"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
