# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nemesis/nemesis-1.4_beta3.ebuild,v 1.9 2006/02/20 20:48:51 jokey Exp $

inherit eutils

DESCRIPTION="A commandline-based, portable human IP stack for UNIX/Linux"
HOMEPAGE="http://www.packetfactory.net/Projects/nemesis/"
SRC_URI="http://www.packetfactory.net/Projects/nemesis/${P/_}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 sparc x86"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	>=net-libs/libnet-1.0.2a-r3
	<net-libs/libnet-1.1"

S=${WORKDIR}/${P/_}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-libnet-1.0.patch
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README
}
