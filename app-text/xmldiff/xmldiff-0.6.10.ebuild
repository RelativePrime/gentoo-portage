# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xmldiff/xmldiff-0.6.10.ebuild,v 1.6 2011/10/23 17:23:31 armin76 Exp $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils python

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="http://www.logilab.org/projects/xmldiff/"
SRC_URI="ftp://ftp.logilab.fr/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86 ~x86-linux"
IUSE=""

DEPEND="dev-python/pyxml"
RDEPEND="${DEPEND}"

DOCS="ChangeLog README README.xmlrev TODO"
