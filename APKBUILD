# Contributor: Piggy90 <piggy90@github.com>
# Maintainer: Piggy90 <piggy90@github.com>
pkgname=crontui
pkgver=1.1.1
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
886142639febc142f1f31bd72900f7e315c278e3679fdad5919d8e0aa40b1d7652d064a00c4021c07b682442bb7ec56fa7e36762dcd0eba56f8313ab566f169e  crontui
"
