# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/foremost/foremost-1.5.7-r1.ebuild,v 1.3 2011/11/23 04:59:11 radhermit Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A console program to recover files based on their headers and footers"
HOMEPAGE="http://foremost.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
# starting to hate sf.net ...
SRC_URI="http://foremost.sourceforge.net/pkg/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
LICENSE="public-domain"
SLOT="0"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.4-config-location.patch"
}

src_compile() {
	emake RAW_FLAGS="${CFLAGS} -Wall ${LDFLAGS}" RAW_CC="$(tc-getCC) -DVERSION=\\\"${PV}\\\"" \
		CONF=/etc
}

src_install() {
	dobin foremost
	doman foremost.8.gz
	insinto /etc
	doins foremost.conf
	dodoc README CHANGES
}
