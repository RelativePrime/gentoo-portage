# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/netcdf/netcdf-4.1.3.ebuild,v 1.1 2011/08/04 17:01:54 bicatali Exp $

EAPI=4

inherit autotools autotools-utils fortran-2

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/netcdf/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="cxx dap doc fortran hdf5 static-libs"

RDEPEND="fortran? ( virtual/fortran )
	dap? ( net-misc/curl )
	hdf5? ( >=sci-libs/hdf5-1.8.6[zlib,szip,fortran?] )"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2
	doc? ( virtual/latex-base )
	fortran? ( dev-lang/cfortran )"

DOCS=(README RELEASE_NOTES)

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.1-parallel-build.patch
	"${FILESDIR}"/${PN}-4.1.1-fortran.patch
)

pkg_setup() {
	if use fortran; then
		FORTRAN_STANDARD="77 90"
		fortran-2_pkg_setup
	fi
	if use hdf5 && has_version sci-libs/hdf5[mpi]; then
		export CC=mpicc
		use cxx && export CXX=mpicxx
		use fortran && export FC=mpif90 F77=mpif77
	fi
}

src_prepare() {
	# use system cfortran
	rm -f fortran/cfortran.h || die
	# check for szip is libsz, not libszip
	sed -i -e 's/\[szip\]/\[sz\]/' configure.ac || die
	# we don't build udunits and libcf
	sed -i -e '/udunits libcf/d' configure.ac || die
	if ! use doc; then
		sed -i -e "/\$(NC_TEST4)/ s/man4//" Makefile.am || die
	fi
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable dap)
		$(use_enable static-libs static)
		$(use_enable fortran f77)
		$(use_enable fortran f90)
		$(use_enable cxx)
		$(use_enable hdf5 netcdf-4)
	)
	autotools-utils_src_configure
}

src_compile() {
	# hack to allow parallel build
	if use doc; then
		autotools-utils_src_compile pdf
		autotools-utils_src_compile -j1 -C man4
	fi
	autotools-utils_src_compile
}
