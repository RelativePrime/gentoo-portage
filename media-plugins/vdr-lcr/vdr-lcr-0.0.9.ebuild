# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-lcr/vdr-lcr-0.0.9.ebuild,v 1.1 2008/08/14 10:59:00 zzam Exp $

inherit vdr-plugin

DESCRIPTION="Video Disk Recorder Least Cost Routing (LCR) PlugIn"
HOMEPAGE="http://lcr.vdr-developer.org"
SRC_URI="http://lcr.vdr-developer.org/downloads/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.5.7
		>=dev-perl/libwww-perl-5.69-r2
		>=dev-perl/HTML-Parser-3.34-r1
		>=www-client/lynx-2.8.4"

src_install() {
	vdr-plugin_src_install

	dobin contrib/vdr-lcr-retrieve_data.pl
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	echo
	elog "By default, this plugin only supports the German telephone network"
	elog "Find more info in /usr/bin/vdr-lcr-retrieve-data.pl how to add your"
	elog "own Provider-Parser, or contact the maintainer"
}
