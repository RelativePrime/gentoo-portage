# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/airsnort/airsnort-0.2.7e.ebuild,v 1.7 2011/04/02 12:49:33 ssuominen Exp $

DESCRIPTION="802.11b Wireless Packet Sniffer/WEP Cracker"
HOMEPAGE="http://airsnort.shmoo.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*
	net-libs/libpcap"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README README.decrypt AUTHORS ChangeLog TODO faq.txt
}

pkg_postinst() {
	elog "Make sure to emerge linux-wlan-ng if you want support"
	elog "for Prism2 based cards in airsnort."

	elog "Make sure to emerge orinoco if you want support"
	elog "for Orinoco based cards in airsnort."
}
