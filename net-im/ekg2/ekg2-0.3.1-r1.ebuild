# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ekg2/ekg2-0.3.1-r1.ebuild,v 1.2 2011/08/30 10:13:22 mgorny Exp $

EAPI=3
inherit autotools-utils versionator

DESCRIPTION="Text-based, multi-protocol instant messenger"
HOMEPAGE="http://www.ekg2.org"
SRC_URI="http://pl.ekg2.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gadu gif gnutls gpg gpm gsm gtk idn inotify jpeg ncurses nls
	oracle perl python readline rss spell sqlite sqlite3 ssl threads unicode
	xmpp xosd zlib"

RDEPEND="
	gpg? ( app-crypt/gpgme )
	gsm? ( media-sound/gsm )
	gtk? ( x11-libs/gtk+:2 )
	idn? ( net-dns/libidn )
	nls? ( virtual/libintl )
	oracle? ( dev-db/oracle-instantclient-basic )
	perl? ( dev-lang/perl )
	python? ( dev-lang/python )
	readline? ( sys-libs/readline )
	ssl? ( dev-libs/openssl )
	xosd? ( x11-libs/xosd )
	zlib? ( sys-libs/zlib )

	gadu? ( net-libs/libgadu
		gif? ( media-libs/giflib )
		jpeg? ( virtual/jpeg ) )
	ncurses? ( sys-libs/ncurses[unicode?]
		gpm? ( sys-libs/gpm )
		spell? ( app-text/aspell ) )
	rss? ( dev-libs/expat )
	sqlite3? ( dev-db/sqlite:3 )
	!sqlite3? ( sqlite? ( dev-db/sqlite:0 ) )
	xmpp? ( dev-libs/expat
		gnutls? ( net-libs/gnutls ) )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/0001-Gentoo-use-vendor-dirs-for-perl-modules.patch
)
DOCS=(
	AUTHORS docs/README docs/TODO
	docs/events.txt docs/mouse.txt docs/sim.txt docs/voip.txt
	docs/themes.txt docs/themes-en.txt
	docs/ui-ncurses.txt docs/ui-ncurses-en.txt
)

# Due to MakeMaker being used to build Perl modules.
AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_setup() {
	if ! use gtk && ! use ncurses && ! use readline; then
		ewarn 'ekg2 is being compiled without any frontend, you should consider'
		ewarn 'enabling at least one of following USEflags:'
		ewarn '  gtk, ncurses, readline.'
	fi

	if use gnutls && ! use ssl; then
		ewarn 'You have enabled USE=gnutls without USE=ssl. The SSL support'
		ewarn 'in ekg2 will be limited to the plugins supporting GnuTLS.'
	fi
}

src_configure() {
	myeconfargs=(
		$(use_with gadu libgadu)
		$(use_with gif)
		# gnutls is jabber-specific
		$(use xmpp && use_with gnutls libgnutls || echo '--without-libgnutls')
		$(use_with gpg)
		$(use_with gpm gpm-mouse)
		$(use_with gsm libgsm)
		$(use_with gtk)
		$(use_with idn libidn)
		$(use_with inotify)
		$(use xmpp && echo '--with-expat' || use_with rss expat)
		$(use_with jpeg libjpeg)
		$(use_with ncurses)
		$(use_with oracle logsoracle)
		$(use_with perl)
		$(use_with python)
		$(use_with readline)
		$(use_with spell aspell)
		$(use_with sqlite)
		$(use_with sqlite3)
		$(use_with ssl openssl)
		$(use_with threads pthread)
		$(use_with xosd libxosd)
		$(use_with zlib)
		$(use_enable nls)
		$(use_enable unicode)
		--without-ioctld
		--disable-remote
		--enable-skip-relative-plugins-dir
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	remove_libtool_files all
}
