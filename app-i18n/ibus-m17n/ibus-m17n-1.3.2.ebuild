# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-m17n/ibus-m17n-1.3.2.ebuild,v 1.2 2011/04/05 19:52:57 flameeyes Exp $

EAPI="3"

DESCRIPTION="The M17N engine IMEngine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk nls"

RDEPEND=">=app-i18n/ibus-1.3
	gtk? ( >=x11-libs/gtk+-2.12.12:2 )
	dev-libs/m17n-lib
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/gettext-0.16.1"
RDEPEND="${RDEPEND}
	dev-db/m17n-db
	dev-db/m17n-contrib"
#	gtk? (
#		|| (
#			>=x11-libs/gtk+-2.90.5:3
#			>=x11-libs/gtk+-2.12.12:2
#		)
#	)

src_configure() {
	local myconf

	econf \
		$(use_with gtk gtk 2.0) \
		$(use_enable nls) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README || die
}
