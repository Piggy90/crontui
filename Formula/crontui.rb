class Crontui < Formula
  desc "Terminal-based visualizer and manager for cronjobs"
  homepage "https://github.com/Piggy90/crontui"
  url "https://github.com/Piggy90/crontui/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0a47cf7aa8184f8a65a1abb99ff88050313741680b7af862fb91ffb612ccf0e0"
  license "MIT"

  depends_on "python"

  def install
    bin.install "crontui"
  end

  test do
    system "#{bin}/crontui", "--version"
  end
end
