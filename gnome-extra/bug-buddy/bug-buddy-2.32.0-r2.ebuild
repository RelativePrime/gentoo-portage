# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/bug-buddy/bug-buddy-2.32.0-r2.ebuild,v 1.7 2011/03/23 07:57:04 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2 eutils

DESCRIPTION="A graphical bug reporting tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="Ximian-logos GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="eds"

RDEPEND=">=gnome-base/libbonobo-2
	>=dev-libs/glib-2.16:2
	>=dev-libs/libxml2-2.4.6
	>=x11-libs/gtk+-2.14:2
	>=net-libs/libsoup-2.4:2.4
	>=gnome-base/libgtop-2.13.3:2
	>=gnome-base/gconf-2:2
	|| ( dev-libs/elfutils dev-libs/libelf )
	>=sys-devel/gdb-5.1
	eds? ( >=gnome-extra/evolution-data-server-1.3 )"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable eds)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_prepare() {
	gnome2_src_prepare

	# Revert this commit as it causes gnome-session to always run in debug mode, bug #348722
	EPATCH_OPTS="-R" epatch "${FILESDIR}/${PN}-2.32.0-gnomesession-debug.patch"
}

pkg_postinst() {
	# Prevent old gnomebreakpad to be requested, bug #348351
	local gconftool="${EROOT}usr/bin/gconftool-2"
	local GCONF_CONFIG_SOURCE="$("${gconftool}" --get-default-source | sed "s;:/;:${ROOT};")"

	"${gconftool}" --direct --config-source "${GCONF_CONFIG_SOURCE}" --type=bool \
		--set /apps/gnome_settings_daemon/gtk-modules/gnomebreakpad false || die

	gnome2_pkg_postinst
}
