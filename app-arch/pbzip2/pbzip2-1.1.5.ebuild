# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pbzip2/pbzip2-1.1.5.ebuild,v 1.7 2011/10/23 12:50:49 armin76 Exp $

EAPI=4

inherit flag-o-matic eutils

DESCRIPTION="Parallel bzip2 (de)compressor using libbz2"
HOMEPAGE="http://compression.ca/pbzip2/"
SRC_URI="http://compression.ca/${PN}/${P}.tar.gz"

LICENSE="PBZIP2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="static symlink"

DEPEND="app-arch/bzip2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.2-makefile.patch
	tc-export CXX
	use static && append-ldflags -static
}

src_install() {
	dobin pbzip2 || die "Failed to install"
	dodoc AUTHORS ChangeLog README || die
	doman pbzip2.1 || die "Failed to install man page"
	dosym pbzip2 /usr/bin/pbunzip2

	if use symlink ; then
		local s
		for s in bzip2 bunzip2 bzcat ; do
			dosym pbzip2 /usr/bin/${s} || die
		done
	fi
}
