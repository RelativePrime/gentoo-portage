# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pkgcore/pkgcore-9999.ebuild,v 1.3 2011/09/20 02:53:25 ferringb Exp $

EAPI="3"
DISTUTILS_SRC_TEST="setup.py"

EGIT_REPO_URI="https://code.google.com/p/pkgcore/"
inherit distutils git-2

DESCRIPTION="pkgcore package manager"
HOMEPAGE="http://pkgcore.googlecode.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/snakeoil-0.4.1
	dev-python/pyparsing
	|| ( >=dev-lang/python-2.5 dev-python/pycrypto )"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/docutils-0.4 )"

DOCS="AUTHORS NEWS"

pkg_setup() {
	# disable snakeoil 2to3 caching...
	unset PY2TO3_CACHEDIR
	python_pkg_setup
}

src_compile() {
	distutils_src_compile

	if use doc; then
		python setup.py build_docs || die "doc generation failed"
		python setup.py build_man || die "man generation failed"
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r build/sphinx/html/*
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	pplugincache

	if [[ -d "${ROOT}etc/pkgcore/plugins" ]]; then
		elog "You still have an /etc/pkgcore/plugins from pkgcore 0.1."
		elog "It is unused by pkgcore >= 0.2, remove it now."
		die "remove /etc/pkgcore/plugins from pkgcore 0.1"
	fi

	# This is left behind by pkgcore 0.2.
	rm -f "${ROOT}"$(python_get_sitedir)/pkgcore/plugins/plugincache
}

pkg_postrm() {
	# Careful not to remove this on up/downgrades.
	local sitep="${ROOT}"$(python_get_sitedir)/site-packages
	if [[ -e "${sitep}/pkgcore/plugins/plugincache2" ]] &&
		! [[ -e "${sitep}/pkgcore/plugin.py" ]]; then
		rm "${sitep}/pkgcore/plugins/plugincache2"
	fi
	distutils_pkg_postrm
}
