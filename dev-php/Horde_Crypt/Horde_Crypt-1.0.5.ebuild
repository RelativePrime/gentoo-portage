# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/Horde_Crypt/Horde_Crypt-1.0.5.ebuild,v 1.1 2011/09/17 10:54:22 a3li Exp $

EAPI=4

inherit php-pear-r1

KEYWORDS="~amd64"
SLOT="0"
DESCRIPTION="Horde Cryptography API"
LICENSE="LGPL-2"
HOMEPAGE="http://www.horde.org/"
SRC_URI="http://pear.horde.org/get/${P}.tgz"

DEPEND="dev-lang/php[hash,ssl]
	>=dev-lang/php-5.2.0
	>=dev-php/PEAR-PEAR-1.7.0
	=dev-php/Horde_Exception-1*
	=dev-php/Horde_Mime-1*
	=dev-php/Horde_Stream_Filter-1*
	=dev-php/Horde_Translation-1*
	=dev-php/Horde_Util-1*"
RDEPEND="${DEPEND}"
