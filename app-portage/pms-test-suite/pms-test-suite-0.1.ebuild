# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/pms-test-suite/pms-test-suite-0.1.ebuild,v 1.2 2011/10/23 22:15:08 tetromino Exp $

EAPI=3

PYTHON_DEPEND='2:2.6'
# Python ABIs are not supported by pkgcore
#SUPPORT_PYTHON_ABIS=1
# Python3 is not supported by dbus & gobject
RESTRICT_PYTHON_ABIS='2.4 2.5 3.*'
DISTUTILS_SRC_TEST=setup.py

inherit base distutils

DESCRIPTION="A test suite for Package Manager PMS compliance"
HOMEPAGE="http://www.gentoo.org/proj/en/qa/pms/pms-test-suite.xml"
SRC_URI="http://cloud.github.com/downloads/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=app-portage/gentoopm-0.1.5
	dev-python/dbus-python
	dev-python/pygobject:2"
DEPEND="doc? ( dev-python/epydoc )
	test? ( >=sys-apps/portage-2.1.10.3
		sys-apps/pkgcore
		>=sys-apps/paludis-0.64.2[python-bindings] )"

PYTHON_MODNAME=pmstestsuite

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	base_src_prepare
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile

	if use doc; then
		"$(PYTHON)" setup.py "${_DISTUTILS_GLOBAL_OPTIONS[@]}" doc || die
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/* || die
	fi
}
