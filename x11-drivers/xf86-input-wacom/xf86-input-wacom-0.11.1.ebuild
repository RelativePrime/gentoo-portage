# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-wacom/xf86-input-wacom-0.11.1.ebuild,v 1.2 2011/09/29 11:45:21 scarabeus Exp $

EAPI=4

inherit linux-info xorg-2

DESCRIPTION="Driver for Wacom tablets and drawing devices"
HOMEPAGE="http://linuxwacom.sourceforge.net/"
LICENSE="GPL-2"
EGIT_REPO_URI="git://linuxwacom.git.sourceforge.net/gitroot/linuxwacom/${PN}"
[[ ${PV} != 9999* ]] && \
	SRC_URI="mirror://sourceforge/linuxwacom/${PN}/${P}.tar.bz2"

KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="debug"

RDEPEND="!x11-drivers/linuxwacom
	>=x11-base/xorg-server-1.7
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-proto/randrproto"

pkg_setup() {
	linux-info_pkg_setup

	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
	)
}

src_install() {
	xorg-2_src_install

	rm -rf "${ED}"/usr/share/hal
}

pkg_pretend() {
	linux-info_pkg_setup

	if ! linux_config_exists \
			|| ! linux_chkconfig_present TABLET_USB_WACOM \
			|| ! linux_chkconfig_present INPUT_EVDEV; then
		echo
		ewarn "If you use a USB Wacom tablet, you need to enable support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Input device support --->"
		ewarn "      <*>   Event interface"
		ewarn "      [*]   Tablets  --->"
		ewarn "        <*>   Wacom Intuos/Graphire tablet support (USB)"
		echo
	fi
}
