# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/columnize/columnize-0.3.3.ebuild,v 1.1 2010/11/07 21:15:27 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Format a simple (i.e. not nested) list into aligned columns."
HOMEPAGE="http://code.google.com/p/pycolumnize/ http://pypi.python.org/pypi/columnize"
SRC_URI="http://pycolumnize.googlecode.com/files/${P}.tar.gz"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

DOCS="README.txt"
PYTHON_MODNAME="columnize.py"
