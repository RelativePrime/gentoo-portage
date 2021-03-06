# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GStreamer-Interfaces/GStreamer-Interfaces-0.04.ebuild,v 1.3 2008/07/02 21:37:24 drac Exp $

inherit perl-module

DESCRIPTION="Perl interface to the GStreamer Interfaces library"
HOMEPAGE="http://search.cpan.org/~tsch"
SRC_URI="mirror://cpan/authors/id/T/TS/TSCH/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc ~x86"
IUSE=""

RDEPEND="=media-libs/gst-plugins-base-0.10*
	>=dev-perl/GStreamer-0.06
	>=dev-perl/glib-perl-1.180"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.205
	>=dev-perl/extutils-pkgconfig-1.07
	dev-util/pkgconfig"
