# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpsysinfo/phpsysinfo-3.0.15.ebuild,v 1.1 2011/11/11 05:05:34 radhermit Exp $

EAPI="4"

inherit webapp depend.php

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP."
HOMEPAGE="http://phpsysinfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/php[simplexml,xml,xsl,unicode]
	|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"

S="${WORKDIR}/${PN}"

need_httpd_cgi
need_php_httpd

src_install() {
	webapp_src_preinst

	dodoc ChangeLog README*
	rm -f ChangeLog COPYING README*

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	newins config.php{.new,}

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_src_install
}
