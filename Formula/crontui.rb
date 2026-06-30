class Crontui < Formula
  desc "Terminal-based visualizer and manager for cronjobs"
  homepage "https://github.com/Piggy90/crontui"
  url "https://github.com/Piggy90/crontui/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a0e1d58ada6042a61be4a03d39674a868a49a381d1fab6fa80213b63770dd017"
  license "MIT"

  depends_on "python"

  def install
    bin.install "crontui"
  end

  test do
    system "#{bin}/crontui", "--version"
  end
end
