# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwallet/kwallet-4.7.3.ebuild,v 1.1 2011/11/02 20:48:20 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	kde_eclass="kde4-base"
else
	KMNAME="kdeutils"
	kde_eclass="kde4-meta"
fi
inherit ${kde_eclass}

DESCRIPTION="KDE Wallet Management Tool"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"
