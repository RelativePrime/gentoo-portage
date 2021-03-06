# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aiksaurus/aiksaurus-1.2.1.ebuild,v 1.16 2011/03/24 09:04:12 ssuominen Exp $

EAPI=2
inherit flag-o-matic eutils libtool

DESCRIPTION="A thesaurus lib, tool and database"
HOMEPAGE="http://sourceforge.net/projects/aiksaurus"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="gtk"

RDEPEND="gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	gtk? ( dev-util/pkgconfig )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch #214248

	# Needed to make relink work on FreeBSD, without it won't install.
	# Also needed for a sane .so versionning there.
	elibtoolize
}

src_configure() {
	filter-flags -fno-exceptions
	econf $(use_with gtk)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README* ChangeLog
}
