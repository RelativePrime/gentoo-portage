# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-tutcode/ibus-tutcode-1.0.1.ebuild,v 1.1 2011/11/09 04:54:11 naota Exp $

EAPI=4

DESCRIPTION="a Japanese TUT-Code input engine for IBus"
HOMEPAGE="https://github.com/deton/ibus-tutcode/"
SRC_URI="https://github.com/downloads/deton/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5
	>=sys-devel/gettext-0.16.1"
RDEPEND="${DEPEND}
	app-i18n/ibus"

src_install() {
	default
	dodoc ${PN}.json.example
}
