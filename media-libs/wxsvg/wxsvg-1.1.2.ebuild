# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/wxsvg/wxsvg-1.1.2.ebuild,v 1.1 2011/09/29 03:19:43 dirtyepic Exp $

EAPI="3"
WX_GTK_VER="2.8"
AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit autotools-utils wxwidgets

DESCRIPTION="C++ library to create, manipulate and render SVG files."
HOMEPAGE="http://wxsvg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="x11-libs/cairo
	x11-libs/wxGTK:2.8[X]
	>=dev-libs/expat-2.0.1-r3
	>=dev-libs/glib-2.12:2
	>=dev-libs/libxml2-2.6.26
	>=media-libs/fontconfig-2.4
	>=media-libs/freetype-2.2.0
	virtual/ffmpeg
	>=x11-libs/pango-1.14.9"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=(AUTHORS ChangeLog TODO)
PATCHES=("${FILESDIR}"/${P}-libav.patch)
