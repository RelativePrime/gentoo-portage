# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbox/dropbox-1.2.48.ebuild,v 1.1 2011/11/16 02:46:06 naota Exp $

EAPI="4"

inherit gnome2-utils

DESCRIPTION="Dropbox daemon (pretends to be GUI-less)."
HOMEPAGE="http://dropbox.com/"
SRC_URI="x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="CCPL-Attribution-NoDerivs-3.0 FTL MIT LGPL-2 openssl dropbox"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

QA_DT_HASH="opt/${PN}/.*"
QA_EXECSTACK_x86="opt/dropbox/_ctypes.so"
QA_EXECSTACK_amd64="opt/dropbox/_ctypes.so"

DEPEND=""
RDEPEND="net-misc/wget"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/.dropbox-dist" "${S}" || die
}

src_install() {
	dodoc README ACKNOWLEDGEMENTS
	rm README ACKNOWLEDGEMENTS || die

	local targetdir="/opt/dropbox"
	insinto "${targetdir}"
	doins -r *
	fperms a+x "${targetdir}/dropbox"
	fperms a+x "${targetdir}/dropboxd"
	dosym "${targetdir}/dropboxd" "/opt/bin/dropbox"

	insinto /usr/share
	doins -r icons
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
