# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tinyxml/tinyxml-2.6.2.ebuild,v 1.5 2011/10/28 08:48:30 chainsaw Exp $

EAPI=4
inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="a simple, small, C++ XML parser that can be easily integrating into other programs"
HOMEPAGE="http://www.grinninglizard.com/tinyxml/index.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV//./_}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~arm amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="debug doc static-libs +stl"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}"

src_prepare() {
	local major_v minor_v
	major_v=$(echo ${PV} | cut -d \. -f 1)
	minor_v=$(echo ${PV} | cut -d \. -f 2-3)

	sed -e "s:@MAJOR_V@:$major_v:" \
	    -e "s:@MINOR_V@:$minor_v:" \
		"${FILESDIR}"/Makefile-2 > Makefile || die

	epatch "${FILESDIR}"/${PN}-2.6.1-entity.patch

	use debug && append-cppflags -DDEBUG
	use stl && append-cppflags -DTIXML_USE_STL

	tc-export AR CXX RANLIB
}

src_install() {
	dolib.so *.so*
	use static-libs && dolib.a *.a

	insinto /usr/include
	doins *.h

	dodoc {changes,readme}.txt

	if use doc; then
		dohtml -r docs/*
	fi
}
