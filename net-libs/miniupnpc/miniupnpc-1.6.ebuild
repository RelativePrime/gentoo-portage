# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/miniupnpc/miniupnpc-1.6.ebuild,v 1.2 2011/08/03 10:02:10 blueness Exp $

EAPI=3
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="python? 2"
RESTRICT_PYTHON_ABIS="3.*"

inherit base distutils eutils toolchain-funcs

DESCRIPTION="UPnP client library and a simple UPnP client"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="python static-libs"

DEPEND="sys-apps/lsb-release"
RDEPEND=""

src_prepare() {
	base_src_prepare

	sed \
		-e 's/^CFLAGS ?= -O -Wall /CFLAGS += /' \
		-i Makefile || die

	if use !static-libs; then
		sed \
			-e '/FILESTOINSTALL =/s/ $(LIBRARY)//' \
			-e '/$(INSTALL) -m 644 $(LIBRARY) $(INSTALLDIRLIB)/d' \
			-i Makefile || die
	fi

	use python && distutils_src_prepare
}

# Upstream cmake causes more trouble than it fixes,
# so we'll just stay with the Makefile for now.

src_compile() {
	emake CC=$(tc-getCC) || die

	use python && distutils_src_compile
}

src_install() {
	emake \
		PREFIX="${D}" \
		INSTALLDIRLIB="${D}usr/$(get_libdir)" \
		install || die

	dodoc README Changelog.txt || die
	doman man3/* || die

	use python && distutils_src_install
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
