# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/slurm/slurm-0.3.3-r1.ebuild,v 1.1 2011/08/01 15:32:40 jer Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="Realtime network interface monitor based on FreeBSD's pppstatus"
HOMEPAGE="http://www.wormulon.net/projects/slurm"
SRC_URI="http://www.wormulon.net/files/code/slurm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-overflow.patch
	eautoreconf
}

src_install() {
	# binary
	dobin slurm

	# themes to use with -t option
	insinto /usr/share/${PN}/themes
	doins themes/*.theme

	# manual and other docs
	doman slurm.1
	dodoc AUTHORS ChangeLog COPYRIGHT FAQ KEYS README THANKS \
		THEMES.txt TODO
}
