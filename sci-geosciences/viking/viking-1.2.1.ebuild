# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/viking/viking-1.2.1.ebuild,v 1.3 2011/07/24 11:20:58 scarabeus Exp $

EAPI=4

inherit base autotools

DESCRIPTION="GPS data editor and analyzer"
HOMEPAGE="http://viking.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="gps nls"
KEYWORDS="~amd64 ~ppc ~x86"

COMMONDEPEND="dev-libs/expat
	dev-libs/glib:2
	net-misc/curl
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	gps? ( >=sci-geosciences/gpsd-2.96 )
"
RDEPEND="${COMMONDEPEND}
	sci-geosciences/gpsbabel
"
DEPEND="${COMMONDEPEND}
	app-text/gnome-doc-utils
	app-text/rarian
	dev-libs/libxslt
	dev-util/pkgconfig
	sys-devel/gettext
"

DOCS=( README doc/GEOCODED-PHOTOS doc/GETTING-STARTED doc/GPSMAPPER )

PATCHES=(
	"${FILESDIR}"/${PN}-gpsd-2.96.patch
	"${FILESDIR}"/${PN}-curl-7.21.7.patch
	"${FILESDIR}"/${PV}-autoreconf.patch
)

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--disable-deprecations \
		--with-libcurl \
		--with-expat \
		--enable-google \
		--enable-terraserver \
		--enable-expedia \
		--enable-openstreetmap \
		--enable-bluemarble \
		--enable-geonames \
		--enable-geocaches \
		--enable-spotmaps \
		--disable-dem24k \
		$(use_enable gps realtime-gps-tracking) \
		$(use_enable nls)
}
