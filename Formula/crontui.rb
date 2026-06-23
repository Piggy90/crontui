class Crontui < Formula
  desc "Terminal-based visualizer and manager for cronjobs"
  homepage "https://github.com/Piggy90/crontui"
  url "https://github.com/Piggy90/crontui/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "f6e276640cf4d34e167baac4a367b982f142f1f0b0c4ba8b6937ad5c08ce0b23"
  license "MIT"

  depends_on "python"

  def install
    bin.install "crontui"
  end

  test do
    system "#{bin}/crontui", "--version"
  end
end
