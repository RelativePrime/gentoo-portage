# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/barcode/barcode-0.98-r1.ebuild,v 1.1 2010/09/06 00:57:37 xmw Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="barcode generator"
HOMEPAGE="http://www.gnu.org/software/barcode/"
SRC_URI="mirror://gnu/barcode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-info.patch
	sed -i -e '/^LDFLAGS =/s:=:+=:' \
		-e "/^aLIBDIR/s:lib:$(get_libdir):" \
		-e '/^INFODIR/s:info:share/info:' \
		-e '/^MAN/s:man:share/man:' \
		Makefile.in || die
}

src_configure() {
	tc-export CC
	econf
}

src_install() {
	emake install prefix="${ED}/usr" || die
	dodoc ChangeLog README TODO doc/barcode.{pdf,ps} || die
}
