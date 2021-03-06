# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/beediff/beediff-1.9.ebuild,v 1.1 2010/02/01 14:34:29 ssuominen Exp $

EAPI=2
inherit eutils qt4-r2

DESCRIPTION="A graphical user interface for comparing and merging files"
HOMEPAGE="http://www.beesoft.pl/index.php?id=beediff"
SRC_URI="http://www.beesoft.pl/download/${PN}_${PV}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e '/QMAKE_CXXFLAGS/d' \
		beediff.pro || die
}

src_install() {
	dobin ${PN} || die
	doicon img/${PN}.png
	make_desktop_entry ${PN} "Beesoft Differ"
	dodoc ChangeLog.txt
}
