# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/blt/blt-2.4z-r10.ebuild,v 1.9 2011/11/20 09:51:57 xarthisius Exp $

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

MY_V_SUFFIX="-8.5.2"

DESCRIPTION="Extension to Tk, adding new widgets, geometry managers, and misc commands"
HOMEPAGE="
	http://blt.sourceforge.net/
	http://jos.decoster.googlepages.com/bltfortk8.5.2"
SRC_URI="http://jos.decoster.googlepages.com/${PN}${PV}${MY_V_SUFFIX}.tar.gz"

IUSE="jpeg static-libs X"
SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="
	dev-lang/tk
	jpeg? ( virtual/jpeg )
	X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}${MY_V_SUFFIX}"

src_prepare() {
	epatch "${FILESDIR}/blt-2.4z-r4-fix-makefile.patch"
	epatch "${FILESDIR}/blt-2.4z-r4-fix-makefile2.patch"
	# From blt-2.4z-6mdk.src.rpm
	epatch "${FILESDIR}"/blt2.4z-64bit.patch

	#epatch "${FILESDIR}"/blt-2.4z-tcl8.5-fix.patch
	epatch "${FILESDIR}"/blt-2.4z-tcl8.5-fixpkgruntime.patch

	epatch "${FILESDIR}"/${P}-ldflags.patch

	# Set the correct libdir and drop RPATH
	sed \
		-e "s:\(^libdir=\${exec_prefix}/\)lib:\1$(get_libdir):" \
		-e 's:LD_RUN_PATH=.*$:LD_RUN_PATH="":g' \
		-i configure* || die "sed configure* failed"
	sed \
		-e "/^scriptdir =/s:lib:$(get_libdir):" \
		-i Makefile.in demos/Makefile.in || die "sed Makefile.in failed"

	epatch "${FILESDIR}"/${P}-linking.patch
	epatch "${FILESDIR}"/${P}-darwin.patch
}

src_configure() {
	# bug 167934
	append-flags -fPIC

	LC_ALL=C \
	econf \
		--x-includes="${EPREFIX}/usr/include" \
		--x-libraries="${EPREFIX}/usr/$(get_libdir)" \
		--with-blt="${EPREFIX}/usr/$(get_libdir)" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)" \
		--with-tk="${EPREFIX}/usr/$(get_libdir)" \
		--with-tclincls="${EPREFIX}/usr/include" \
		--with-tkincls="${EPREFIX}/usr/include" \
		--with-tcllibs="${EPREFIX}/usr/$(get_libdir)" \
		--with-tklibs="${EPREFIX}/usr/$(get_libdir)" \
		--with-cc="$(tc-getCC)" \
		--with-cflags="${CFLAGS}" \
		--with-gnu-ld \
		$(use_enable jpeg) \
		$(use_with X x)

}

src_compile() {
	# parallel borks
	emake -j1 LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	sed \
		-e "s:\.\./src/bltwish:${EPREFIX}/usr/bin/bltwish:g" \
		-e "s:\.\./bltwish:${EPREFIX}/usr/bin/bltwish:g" \
		-e "s:/usr/local/bin/bltwish:${EPREFIX}/usr/bin/bltwish:g" \
		-e "s:/usr/local/bin/tclsh:${EPREFIX}/usr/bin/tclsh:g" \
		-i demos/{,scripts/}*.tcl || die

	dodir /usr/bin \
		/usr/$(get_libdir)/blt2.4/demos/bitmaps \
		/usr/share/man/mann \
		/usr/include \
			|| die "dodir failed"
	emake -j1 INSTALL_ROOT="${D}" install || die "make install failed"

	dodoc NEWS PROBLEMS README
	dohtml html/*.html
	for f in `ls "${ED}"/usr/share/man/mann` ; do
		mv "${ED}"/usr/share/man/mann/${f} "${ED}"/usr/share/man/mann/${f/.n/.nblt}
	done

	# bug 259338 - dev-tcltk/blt-2.4z-r4 provides empty pkgIndex.tcl
	cp "${FILESDIR}"/pkgIndex.tcl "${ED}"/usr/$(get_libdir)/blt2.4/pkgIndex.tcl

	# fix for linking against shared lib with -lBLT or -lBLTlite
	dosym libBLT24$(get_libname) /usr/$(get_libdir)/libBLT$(get_libname) || die
	dosym libBLTlite24$(get_libname) /usr/$(get_libdir)/libBLTlite$(get_libname) || die

	use static-libs || \
		find "${ED}"/usr/$(get_libdir) -name "*.a" -print0 | \
		xargs -r -0 rm -fv
}
