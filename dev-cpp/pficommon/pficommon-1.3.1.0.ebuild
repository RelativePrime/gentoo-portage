# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/pficommon/pficommon-1.3.1.0.ebuild,v 1.1 2011/11/12 23:55:49 naota Exp $

EAPI=4

inherit waf-utils eutils

DESCRIPTION="General purpose C++ library for PFI"
HOMEPAGE="https://github.com/pfi/pficommon"
SRC_URI="https://github.com/pfi/pficommon/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fcgi imagemagick mprpc mysql postgres test"

RDEPEND="fcgi? ( dev-libs/fcgi )
	imagemagick? (
		media-libs/lcms
		media-gfx/imagemagick[cxx]
		sys-devel/libtool
	)
	mprpc? ( dev-libs/msgpack )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_unpack() {
	unpack ${A}
	mv pfi-pficommon-* "${S}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libdir.patch \
		"${FILESDIR}"/${P}-soname.patch \
		"${FILESDIR}"/${P}-postgresql.patch
}

src_configure() {
	if use fcgi; then
		myconf="${myconf} --with-fcgi=/usr"
	else
		myconf="${myconf} --disable-fcgi"
	fi
	use imagemagick || myconf="${myconf} --disable-magickpp"
	use mprpc || myconf="${myconf} --disable-mprpc"
	if ! use mysql && ! use postgres; then
		myconf="${myconf} --disable-database"
	fi
	waf-utils_src_configure ${myconf}
}
