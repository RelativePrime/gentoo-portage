# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/enchant/enchant-1.6.0.ebuild,v 1.13 2011/08/14 05:06:19 nirbheek Exp $

EAPI="3"
inherit libtool confutils autotools

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="http://www.abisource.com/enchant/"
SRC_URI="http://www.abisource.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="aspell +hunspell static-libs zemberek"

COMMON_DEPENDS="dev-libs/glib:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1 )
	zemberek? ( dev-libs/dbus-glib )"

RDEPEND="${COMMON_DEPENDS}
	zemberek? ( app-text/zemberek-server )"

# libtool is needed for the install-sh to work
DEPEND="${COMMON_DEPENDS}
	dev-util/pkgconfig"

pkg_setup() {
	confutils_require_any aspell hunspell zemberek
}

src_prepare() {
	sed -i -e 's:noinst_PROGRAMS:check_PROGRAMS:' tests/Makefile.am \
		|| die "unable to remove testdefault build"
	eautoreconf
}

src_configure() {
	econf $(use_enable aspell) \
		$(use_enable hunspell myspell) \
		$(use_with hunspell system-myspell) \
		$(use_enable static-libs static) \
		$(use_enable zemberek) \
		--disable-ispell \
		--with-myspell-dir="${EPREFIX}"/usr/share/myspell/
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README TODO

	if ! use static-libs; then
		# Remove useless .la files
		find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
	fi
}

pkg_postinst() {
	ewarn "Starting with ${PN}-1.4.0 default spell checking engine has changed"
	ewarn "from aspell to hunspell. In case you used aspell dictionaries to"
	ewarn "check spelling you need either reemerge ${PN} with aspell USE flag"
	ewarn "or you need to emerge myspell-<lang> dictionaries."
	ewarn "aspell is faster but has less features then hunspell and most"
	ewarn "distributions by default use hunspell only. Nevertheless in Gentoo"
	ewarn "it's still your choice which library to use..."
}
