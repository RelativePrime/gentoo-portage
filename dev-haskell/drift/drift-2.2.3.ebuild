# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/drift/drift-2.2.3.ebuild,v 1.1 2011/08/01 21:44:11 slyfox Exp $

inherit ghc-package

MY_PN="DrIFT"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Preprocessor for automatic derivation of Haskell class instances"
HOMEPAGE="http://repetae.net/john/computer/haskell/DrIFT/"
SRC_URI="http://repetae.net/john/computer/haskell/DrIFT/drop/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE=""

DEPEND=">=dev-lang/ghc-6"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --with-hc="$(ghc-getghc)" || die "configure failed"
	# Makefile has no parallelism
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
