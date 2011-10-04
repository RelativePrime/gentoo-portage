# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/partitionmanager/partitionmanager-1.0.3_p20110912.ebuild,v 1.3 2011/10/04 11:01:43 chainsaw Exp $

EAPI=4

KMNAME="extragear/sysadmin"
inherit kde4-base

DESCRIPTION="KDE utility for management of partitions and file systems."
HOMEPAGE="http://partitionman.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-libs/libatasmart
	>=sys-block/parted-3
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
