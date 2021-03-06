# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/webtest/webtest-1.3.ebuild,v 1.2 2011/09/19 21:53:36 maekke Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

MY_PN="WebTest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Helper to test WSGI applications"
HOMEPAGE="http://pythonpaste.org/webtest/ http://pypi.python.org/pypi/WebTest"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

RDEPEND=">=dev-python/webob-0.9.2"
DEPEND="${RDEPEND}
	dev-python/setuptools
	doc? ( dev-python/sphinx )
	test? ( dev-python/pyquery )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-doctest-ellipsis.patch"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		sphinx-build docs html || die "Building of documentation failed"
	fi
}

src_install() {
	distutils_src_install

	# Avoid future-import bug on py2.5.* - lint3 is py3 anyway
	delete_lint3() {
		[[ "${PYTHON_ABI}" == 3.* ]] && return
		rm "${ED}$(python_get_sitedir)/webtest/lint3.py"
	}
	python_execute_function -q delete_lint3

	if use doc; then
		dohtml -r html/* || die "Error installing docs"
	fi
}
