# Contributor: Piggy90 <piggy90@github.com>
# Maintainer: Piggy90 <piggy90@github.com>
pkgname=crontui
pkgver=1.0.0
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
3ed7619194ce751fa7567a65ff194bd94a0dd42e231720ff9e04d6a159100c99016b92302e1ac2262f272d4a1fd337d6ba3b8ead6188fd6aa0f54b083302ec01  crontui
"
