# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/smbtad/smbtad-1.2.3.ebuild,v 1.1 2011/03/24 09:42:30 dagger Exp $

EAPI="4"
inherit cmake-utils

DESCRIPTION="Data receiver of the SMB Traffic Analyzer project"
HOMEPAGE="http://github.com/hhetter/smbtad"
SRC_URI="http://morelias.org/smbta/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-util/cmake
	>=dev-db/sqlite-3.5"
RDEPEND="net-fs/samba[smbtav2]"

DOCS="README AUTHORS"

src_configure() {
	mycmakeargs="${mycmakeargs} \
		$(cmake-utils_use debug DEBUG)"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/smbtad.rc smbtad
	newconfd dist/smbtad.conf_example smbtad.conf

}
