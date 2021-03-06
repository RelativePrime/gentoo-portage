# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/nodejs/nodejs-0.4.12.ebuild,v 1.2 2011/10/30 09:20:59 phajdan.jr Exp $

EAPI="2"

inherit eutils

# omgwtf
RESTRICT="test"

DESCRIPTION="Evented IO for V8 Javascript"
HOMEPAGE="http://nodejs.org/"
SRC_URI="http://nodejs.org/dist/node-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/v8-3.5.10.22
	dev-libs/openssl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/node-v${PV}

src_prepare() {
	epatch "${FILESDIR}/${PN}-v8-3.5.patch" # bug #386683
}

src_configure() {
	# this is a waf confuserator
	./configure --shared-v8 --prefix=/usr || die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}

src_test() {
	emake test || die
}
