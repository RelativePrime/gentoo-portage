# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/gnubiff/gnubiff-2.2.13-r2.ebuild,v 1.2 2011/11/22 16:07:36 phajdan.jr Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="A mail notification program"
HOMEPAGE="http://gnubiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 x86"
IUSE="debug fam gnome nls password"

RDEPEND=">=x11-libs/gtk+-2.6:2
	>=gnome-base/libglade-2.3
	dev-libs/popt
	gnome? (
		|| ( gnome-base/gnome-panel[bonobo] <gnome-base/gnome-panel-2.32 )
		>=gnome-base/libgnome-2.2
		>=gnome-base/libgnomeui-2.2 )
	password? ( dev-libs/openssl )
	fam? ( virtual/fam )
	x11-proto/xproto"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-nls.patch
	epatch "${FILESDIR}"/${P}-gold.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable gnome) \
		$(use_enable nls) \
		$(use_enable fam) \
		$(use_with password) \
		$(use_with password password-string ${RANDOM}${RANDOM}${RANDOM}${RANDOM})
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
