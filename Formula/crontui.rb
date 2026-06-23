class Crontui < Formula
  desc "Terminal-based visualizer and manager for cronjobs"
  homepage "https://github.com/Piggy90/crontui"
  url "https://github.com/Piggy90/crontui/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0e80ebf285d27ba291c505d73ae6ddd86462d0334e16700b0794ba8732d6c375"
  license "MIT"

  depends_on "python"

  def install
    bin.install "crontui"
  end

  test do
    system "#{bin}/crontui", "--version"
  end
end
