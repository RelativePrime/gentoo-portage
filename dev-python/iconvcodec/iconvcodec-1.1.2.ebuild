# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/iconvcodec/iconvcodec-1.1.2.ebuild,v 1.8 2010/09/29 22:21:34 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python Codecs for Iconv Encodings"
HOMEPAGE="http://cjkpython.i18n.org/"
SRC_URI="mirror://berlios/cjkpython/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ia64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="iconv_codec.py"

src_compile() {
	distutils_src_compile --with-libc
}
