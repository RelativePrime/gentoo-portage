# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/yelp/yelp-2.30.2-r6.ebuild,v 1.3 2011/11/24 03:49:04 tetromino Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://projects.gnome.org/yelp/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
# FIXME: lzma/xz support will be fixed in yelp3, bug #314923
IUSE=""

RDEPEND=">=gnome-base/gconf-2:2
	>=app-text/gnome-doc-utils-0.19.1
	>=x11-libs/gtk+-2.18:2
	>=dev-libs/glib-2.16:2
	>=dev-libs/libxml2-2.6.5:2
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/dbus-glib-0.71
	net-libs/xulrunner:1.9
	sys-libs/zlib
	app-arch/bzip2
	>=app-text/rarian-0.7
	>=app-text/scrollkeeper-9999"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	gnome-base/gnome-common"
# If eautoreconf:
#	gnome-base/gnome-common

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--with-gecko=libxul-embedding
		--with-search=basic
		--disable-lzma"
}

src_prepare() {
	gnome2_src_prepare

	# Fix automagic lzma support, bug #266128
	epatch "${FILESDIR}/${PN}-2.26.0-automagic-lzma.patch"

	# Fix build with xulrunner-1.9.2
	epatch "${FILESDIR}/${PN}-2.28.1-system-nspr.patch"

	# Fix build with xulrunner-2.0 (we really need to get rid of this package)
	epatch "${FILESDIR}/${P}-port-to-xulrunner-2-r2.patch"

	# Use g_build_filename to avoid missing slash problem
	epatch "${FILESDIR}/${P}-missing-slash.patch"

	# Add schemehandler information to the desktop file
	epatch "${FILESDIR}/${P}-uri-handler.patch"

	# Fix crash when printing a whole document
	epatch "${FILESDIR}/${P}-print-crash.patch"

	# Fix crash and infinite loop when printing HTML document
	epatch "${FILESDIR}/${P}-html-print.patch"

	# Fix small freezes when moving window
	epatch "${FILESDIR}/${P}-freeze-move.patch"

	# Ensure schema is regenerated properly to prevent warnings
	rm -f data/yelp.schemas || die

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	# strip stupid options in configure, see bug #196621
	sed -i 's|$AM_CFLAGS -pedantic -ansi|$AM_CFLAGS|' configure || die "sed	failed"
}
