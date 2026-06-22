class Crontui < Formula
  desc "Terminal-based visualizer and manager for cronjobs"
  homepage "https://github.com/Piggy90/crontui"
  url "https://github.com/Piggy90/crontui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_SHA256_AFTER_RELEASING"
  license "MIT"

  depends_on "python"

  def install
    bin.install "crontui"
  end

  test do
    system "#{bin}/crontui", "--version"
  end
end
