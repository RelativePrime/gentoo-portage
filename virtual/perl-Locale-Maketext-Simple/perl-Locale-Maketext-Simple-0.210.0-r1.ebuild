# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Locale-Maketext-Simple/perl-Locale-Maketext-Simple-0.210.0-r1.ebuild,v 1.3 2011/07/07 23:07:40 aballier Exp $

DESCRIPTION="Virtual for ${PN#perl-}"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="|| ( =dev-lang/perl-5.14* ~dev-lang/perl-5.12.4 ~dev-lang/perl-5.12.3 ~dev-lang/perl-5.12.2 ~perl-core/${PN#perl-}-${PV} )"
