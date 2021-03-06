# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdf2djvu/pdf2djvu-0.7.11.ebuild,v 1.1 2011/10/19 16:00:02 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="convert PDF files to DjVu ones"
HOMEPAGE="http://code.google.com/p/pdf2djvu/"
SRC_URI="http://pdf2djvu.googlecode.com/files/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphicsmagick nls openmp"

RDEPEND=">=app-text/djvu-3.5.21
	>=app-text/poppler-0.16.7[xpdf-headers]
	dev-libs/libxml2
	dev-libs/libxslt
	graphicsmagick? ( media-gfx/graphicsmagick )"
DEPEND="${RDEPEND}
	dev-cpp/pstreams
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	local openmp=disable
	use openmp && tc-has-openmp && openmp=enable

	econf \
		--${openmp}-openmp \
		$(use_enable nls) \
		$(use_with graphicsmagick)
}

src_test() {
	use graphicsmagick && emake test
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/{changelog,*.txt}
}
