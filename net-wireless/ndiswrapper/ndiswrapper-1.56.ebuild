# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ndiswrapper/ndiswrapper-1.56.ebuild,v 1.7 2011/02/19 16:53:04 angelos Exp $

EAPI=2
inherit base linux-mod toolchain-funcs

DESCRIPTION="Wrapper for using Windows drivers for some wireless cards"
HOMEPAGE="http://ndiswrapper.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/stable/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="debug usb"

DEPEND="sys-apps/pciutils"
RDEPEND="${DEPEND}
	net-wireless/wireless-tools"

PATCHES=( "${FILESDIR}"/${P}-cflags.patch "${FILESDIR}"/${P}-ldflags.patch
		"${FILESDIR}"/${P}-2.6.35.patch "${FILESDIR}"/${P}-2.6.36.patch
		"${FILESDIR}"/${P}-2.6.38.patch )
MODULE_NAMES="ndiswrapper(misc:${S}/driver)"
BUILD_TARGETS="all"
MODULESD_NDISWRAPPER_ALIASES=("wlan0 ndiswrapper")

pkg_setup() {
	echo
	einfo "See http://www.gentoo.org/doc/en/gentoo-kernel.xml"
	einfo "for a list of supported kernels."
	echo

	CONFIG_CHECK="WIRELESS_EXT"
	use usb && CONFIG_CHECK="${CONFIG_CHECK} USB"
	ERROR_USB="You need to enable USB support in your kernel to use usb support in ndiswrapper."
	ERROR_WIRELESS_EXT="Starting with 2.6.33 it is not possible to select WIRELESS_EXT anymore, you have to enable a wireless driver that enables WIRELESS_EXT, for example PRISM54 or IPW2200"
	linux-mod_pkg_setup
}

src_compile() {
	local params

	# Enable verbose debugging information
	if use debug; then
		params="DEBUG=3"
		use usb && params="${params} USB_DEBUG=1"
	fi

	cd utils
	emake CC=$(tc-getCC) || die "Compile of utils failed!"

	use usb || params="${params} DISABLE_USB=1"

	BUILD_PARAMS="KSRC=${KV_DIR} KVERS=${KV_FULL} KBUILD='${KV_OUT_DIR}' ${params}"
	linux-mod_src_compile
}

src_install() {
	dodoc AUTHORS ChangeLog INSTALL README || die "dodoc failed"
	doman ndiswrapper.8 || die "doman failed"

	keepdir /etc/ndiswrapper

	linux-mod_src_install

	cd utils
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	echo
	elog "NDISwrapper requires .inf and .sys files from a Windows(tm) driver"
	elog "to function. Download these to /root for example, then"
	elog "run 'ndiswrapper -i /root/foo.inf'. After that you can delete them."
	elog "They will be copied to /etc/ndiswrapper/."
	elog "Once done, please run 'update-modules'."
	echo

	elog "Please look at ${HOMEPAGE}"
	elog "for the FAQ, HowTos, tips, configuration, and installation"
	elog "information."
	echo

	for i in $(lspci -n | egrep '(0280|0200):' |  cut -d' ' -f1)
	do
		i_desc=$(lspci -nn | grep "$i" | awk -F': ' '{print $2}' | awk -F'[' '{print $1}')
		if [[ -n "${i_desc}" ]] ; then
			elog "Possible hardware: ${i_desc}"
		fi
	done

	echo
	elog "NDISwrapper devs need support (_hardware_, cash)."
	elog "Don't hesitate if you can help."
	elog "See ${HOMEPAGE} for details."
	echo

	if [[ ${ROOT} == "/" ]]; then

		einfo "Attempting to automatically reinstall any Windows drivers"
		einfo "you might already have."
		echo

		local driver
		for driver in $(ls /etc/ndiswrapper) ; do
			einfo "Driver: ${driver}"
			mv "/etc/ndiswrapper/${driver}" "${T}"
			ndiswrapper -i "${T}/${driver}/${driver}.inf"
		done
	fi
}
