# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libva-intel-driver/libva-intel-driver-9999.ebuild,v 1.1 2011/11/04 12:56:03 aballier Exp $

EAPI="3"

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-2
	EGIT_BRANCH=master
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/vaapi/intel-driver"
fi

inherit autotools ${SCM} multilib

DESCRIPTION="HW video decode support for Intel integrated graphics"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
	S="${WORKDIR}/${PN}"
else
	MY_P=${P#libva-}
	SRC_URI="http://cgit.freedesktop.org/vaapi/intel-driver/snapshot/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE=""

RDEPEND=">=x11-libs/libva-1.0.14
	!<x11-libs/libva-1.0.15[video_cards_intel]
	>=x11-libs/libdrm-2.4.23[video_cards_intel]"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README || die
	find "${D}" -name '*.la' -delete
}
