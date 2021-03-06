# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/htdig/htdig-3.2.0_beta6-r3.ebuild,v 1.10 2010/01/20 18:03:13 armin76 Exp $

inherit eutils autotools

MY_PV=${PV/_beta/b}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="HTTP/HTML indexing and searching system"
HOMEPAGE="http://www.htdig.org"
SRC_URI="http://www.htdig.org/files/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="ssl"

DEPEND=">=sys-libs/zlib-1.1.3
	app-arch/unzip
	ssl? ( dev-libs/openssl )"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-as-needed.patch
	epatch "${FILESDIR}"/${P}-quoting.patch
	eautoreconf
}

src_compile() {
	use prefix || EPREFIX=

	econf \
		--with-config-dir="${EPREFIX}"/etc/${PN} \
		--with-default-config-file="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--with-database-dir="${EPREFIX}"/var/lib/${PN}/db \
		--with-cgi-bin-dir="${EPREFIX}"/var/www/localhost/cgi-bin \
		--with-search-dir="${EPREFIX}"/var/www/localhost/htdocs/${PN} \
		--with-image-dir="${EPREFIX}"/var/www/localhost/htdocs/${PN} \
		$(use_with ssl)

#		--with-image-url-prefix="file://${EPREFIX}/var/www/localhost/htdocs/${PN}" \

	emake || die "emake failed"
}

src_install () {
	use prefix || ED="${D}"

	emake DESTDIR="${D}" install || die "make install failed"

	dodoc ChangeLog README
	dohtml -r htdoc

	sed -i "s:${D}::g" \
		"${ED}"/etc/${PN}/${PN}.conf \
		"${ED}"/usr/bin/rundig \
		|| die "sed failed (removing \${D} from installed files)"

	# symlink htsearch so it can be easily found. see bug #62087
	dosym ../../var/www/localhost/cgi-bin/htsearch /usr/bin/htsearch
}
