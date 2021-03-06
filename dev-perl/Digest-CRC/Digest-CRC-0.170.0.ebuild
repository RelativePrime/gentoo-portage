# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Digest-CRC/Digest-CRC-0.170.0.ebuild,v 1.1 2011/10/30 16:09:53 maksbotan Exp $

EAPI=3

MODULE_AUTHOR="OLIMAUL"
MODULE_VERSION="0.17"

inherit perl-module

DESCRIPTION="Generic CRC function"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.380.0"

SRC_TEST="do"
