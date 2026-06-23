# Contributor: Piggy90 <piggy90@github.com>
# Maintainer: Piggy90 <piggy90@github.com>
pkgname=crontui
pkgver=1.1.0
pkgrel=0
pkgdesc="Terminal-based visualizer and manager for cronjobs"
url="https://github.com/Piggy90/crontui"
arch="noarch"
license="MIT"
depends="python3"
options="!strip" # Do not try to strip python/bash scripts
source="crontui"

build() {
	return 0
}

package() {
	install -Dm755 "$srcdir"/crontui "$pkgdir"/usr/bin/crontui
}




sha512sums="
80dd2aff4547bf336492eb4879b1c64faca59abb9eb2a9f1deae5367c34461447c4833519802d90ef4c304dcb7b08cc9fbc8c3f018e7f78ad3b15df73124e20a  crontui
"
