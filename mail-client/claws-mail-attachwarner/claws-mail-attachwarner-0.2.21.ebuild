# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-attachwarner/claws-mail-attachwarner-0.2.21.ebuild,v 1.3 2011/07/16 18:17:02 hwoarang Exp $

MY_P="${P#claws-mail-}"

DESCRIPTION="Warn about missing attachment, if it's mentioned in message body."
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"
RDEPEND=">=mail-client/claws-mail-3.7.9
		nls? ( >=sys-devel/gettext-0.12.1 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf $(use_enable nls) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
