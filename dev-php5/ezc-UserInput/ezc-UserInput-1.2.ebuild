# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-UserInput/ezc-UserInput-1.2.ebuild,v 1.1 2008/01/13 16:10:36 jokey Exp $

EZC_BASE_MIN="1.4"
inherit php-ezc depend.php

DESCRIPTION="This eZ component assists you to safely import user input variables into your application."
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

pkg_setup() {
	require_php_with_use filter
}
