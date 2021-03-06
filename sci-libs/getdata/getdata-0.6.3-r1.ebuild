# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/getdata/getdata-0.6.3-r1.ebuild,v 1.3 2011/09/19 16:03:52 jlec Exp $

EAPI=3

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"

FORTRAN_STANDARD="95"

inherit autotools fortran-2 python

DESCRIPTION="Reference implementation of the Dirfile, format for time-ordered binary data"
HOMEPAGE="http://getdata.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 fortran lzma python static-libs"

DEPEND="
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	# Python bindings are built/tested/installed manually.
	sed -e "/PY_SUBDIR/s/python//" -i bindings/Makefile.am
	eautoreconf
}

src_configure() {
	econf \
		--disable-idl \
		--without-libslim \
		--with-libz \
		--enable-shared \
		--docdir="${EPREFIX}/usr/share/doc/${P}" \
		$(use_enable fortran) \
		$(use_enable fortran fortran95) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_with bzip2 libbz2) \
		$(use_with lzma liblzma)
}

src_compile() {
	default

	if use python; then
		python_copy_sources bindings/python
		building() {
			sed "s:-lpython...:$(python_get_library --linker-option):g" -i Makefile || die
			emake \
				PYTHON_VERSION="$(python_get_version)" \
				NUMPY_CPPFLAGS="-I${EPREFIX}$(python_get_sitedir)/numpy/core/include" \
				PYTHON_CPPFLAGS="-I${EPREFIX}$(python_get_includedir)" \
				pyexecdir="$(python_get_sitedir)" \
				pythondir="$(python_get_sitedir)"
		}
		python_execute_function -s --source-dir bindings/python building
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	if use python; then
		installation() {
			emake \
				DESTDIR="${D}" \
				PYTHON_VERSION="$(python_get_version)" \
				NUMPY_CPPFLAGS="-I${EPREFIX}$(python_get_sitedir)/numpy/core/include" \
				PYTHON_CPPFLAGS="-I${EPREFIX}$(python_get_includedir)" \
				PYTHON_VERSION="$(python_get_version)" \
				pyexecdir="$(python_get_sitedir)" \
				pythondir="$(python_get_sitedir)" \
				install
				if use static-libs; then
					find "${ED}/$(python_get_sitedir)" -type f -name "*.a" -delete || die
				fi
		}
		python_execute_function -s --source-dir bindings/python installation
		python_clean_installation_image
	fi
	dodoc AUTHORS ChangeLog NEWS README TODO || die "Installing docs failed"
}
