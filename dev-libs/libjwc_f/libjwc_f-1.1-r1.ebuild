# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libjwc_f/libjwc_f-1.1-r1.ebuild,v 1.9 2011/06/21 16:12:50 jlec Exp $

EAPI="2"

inherit autotools eutils fortran-2

PATCH="612"

DESCRIPTION="additional fortran library for ccp4"
HOMEPAGE="http://www.ccp4.ac.uk/main.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/jwc/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x64-macos"

IUSE=""
RDEPEND="
	virtual/fortran
	"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PATCH}-gentoo.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README
	dohtml doc/*
}
