class Octomon < Formula
  desc "Terminal dashboard for network performance: latency, bandwidth, per-process usage, Wi-Fi signal"
  homepage "https://github.com/securitypedant/octomon"
  url "https://github.com/securitypedant/octomon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e22aa90d8f4076fadbfb51de1b212134e0302e1b5172e35f030283e9a0376e8c"
  license "MIT OR Apache-2.0"
  head "https://github.com/securitypedant/octomon.git", branch: "main"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "octomon", shell_output("#{bin}/octomon --version")
  end
end
