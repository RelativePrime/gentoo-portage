# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-libvisual/gst-plugins-libvisual-0.10.35.ebuild,v 1.2 2011/09/20 03:45:04 phajdan.jr Exp $

inherit gst-plugins-base

KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/libvisual-0.4
	>=media-plugins/libvisual-plugins-0.4"
DEPEND="${RDEPEND}"
