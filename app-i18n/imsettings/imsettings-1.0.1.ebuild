# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/imsettings/imsettings-1.0.1.ebuild,v 1.1 2011/02/01 00:07:39 matsuu Exp $

EAPI=3

DESCRIPTION="Delivery framework for general Input Method configuration"
HOMEPAGE="http://code.google.com/p/imsettings/"
SRC_URI="http://imsettings.googlecode.com/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 static-libs xfconf"

# X11 connections are required for test.
RESTRICT="test"

RDEPEND=">=dev-libs/check-0.9.4
	>=dev-libs/glib-2.26
	sys-apps/dbus
	>=x11-libs/gtk+-2.12:2
	>=x11-libs/libgxim-0.3.1
	x11-libs/libnotify
	x11-libs/libX11
	qt4? ( x11-libs/qt-core:4 )
	xfconf? ( xfce-base/xfconf )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

MY_XINPUTSH="90-xinput"

src_prepare() {
	# Prevent automagic linking to libxfconf-0.
	if ! use xfconf; then
		sed -i -e 's:libxfconf-0:dIsAbLe&:' configure || die
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-xinputsh="${MY_XINPUTSH}"
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${ED}" -name '*.la' -exec rm -f '{}' +

	fperms 0755 /usr/libexec/xinputinfo.sh || die
	fperms 0755 "/etc/X11/xinit/xinitrc.d/${MY_XINPUTSH}" || die

	dodoc AUTHORS ChangeLog NEWS README || die
}

pkg_postinst() {
	if [ ! -e "${EPREFIX}/etc/X11/xinit/xinputrc" ] ; then
		ln -sf xinput.d/xcompose.conf "${EPREFIX}/etc/X11/xinit/xinputrc"
	fi
}
