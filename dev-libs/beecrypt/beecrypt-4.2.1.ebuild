# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/beecrypt/beecrypt-4.2.1.ebuild,v 1.14 2011/11/13 18:46:39 vapier Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"

inherit eutils multilib autotools java-pkg-opt-2 python

DESCRIPTION="general-purpose cryptography library"
HOMEPAGE="http://sourceforge.net/projects/beecrypt/"
SRC_URI="mirror://sourceforge/beecrypt/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="java cxx python threads doc"

COMMONDEPEND="!<app-arch/rpm-4.2.1
	threads? ( cxx? ( >=dev-libs/icu-2.8 ) )"

DEPEND="${COMMONDEPEND}
	java? ( >=virtual/jdk-1.4 )
	doc? ( app-doc/doxygen
		virtual/latex-base
		dev-texlive/texlive-fontsextra
	)"
RDEPEND="${COMMONDEPEND}
	java? ( >=virtual/jre-1.4 )"

pkg_setup() {
	use python && python_set_active_version 2
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	use python && python_convert_shebangs -r 2 .

	epatch "${FILESDIR}"/${P}-build-system.patch
	eautoreconf
}

src_configure() {
	# cpluscplus needs threads support
	econf \
		--disable-expert-mode \
		$(use_enable threads) \
		$(use_with python python "${EPREFIX}"/usr/bin/python2) \
		$(use threads && use_with cxx cplusplus || echo --without-cplusplus) \
		$(use_with java)
}

src_compile() {
	default

	if use doc
	then
		cd include/beecrypt
		doxygen || die "doxygen failed"
	fi
}

src_test() {
	export BEECRYPT_CONF_FILE="${T}/beecrypt-test.conf"
	echo "provider.1=${S}/c++/provider/.libs/base.so" > "${BEECRYPT_CONF_FILE}"
	emake check || die "self test failed"
	emake bench || die "self benchmark test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	rm -f "${ED}"/usr/$(get_libdir)/python*/site-packages/_bc.*a

	dodoc BUGS README BENCHMARKS NEWS || die "dodoc failed"
	if use doc
	then
		dohtml -r docs/html/. || die "dohtml failed"
	fi
}
