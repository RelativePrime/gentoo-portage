# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/gauche-qdbm/gauche-qdbm-0.2.ebuild,v 1.7 2011/11/03 09:24:52 hattya Exp $

EAPI="4"

inherit autotools eutils

MY_P="${P/g/G}"

DESCRIPTION="QDBM binding for Gauche"
HOMEPAGE="http://sourceforge.jp/projects/gauche/"
SRC_URI="mirror://sourceforge.jp/gauche/6988/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc x86"
IUSE=""

RDEPEND="dev-scheme/gauche
	dev-db/qdbm"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gpd.diff
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README

	insinto "$(gauche-config --sitelibdir)"/.packages
	doins ${MY_P%-*}.gpd
}
