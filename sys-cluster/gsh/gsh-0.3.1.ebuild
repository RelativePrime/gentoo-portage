# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/gsh/gsh-0.3.1.ebuild,v 1.1 2010/11/23 12:38:37 xarthisius Exp $

EAPI=3
PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="aggregate several remote shells into one"
HOMEPAGE="http://guichaz.free.fr/gsh/"
SRC_URI="http://guichaz.free.fr/gsh/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
