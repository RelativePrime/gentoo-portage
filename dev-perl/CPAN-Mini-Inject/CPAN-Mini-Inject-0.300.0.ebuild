# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Mini-Inject/CPAN-Mini-Inject-0.300.0.ebuild,v 1.1 2011/06/14 11:24:01 tove Exp $

EAPI=4

MODULE_AUTHOR=MITHALDU
MODULE_VERSION=0.30
inherit perl-module

DESCRIPTION="Inject modules into a CPAN::Mini mirror. "

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE=""

# Disabled
#SRC_TEST="do"

RDEPEND="dev-perl/libwww-perl
	virtual/perl-IO-Compress
	virtual/perl-Archive-Tar
	virtual/perl-File-Path
	virtual/perl-File-Temp
	>=virtual/perl-Module-Build-0.380.0
	>=dev-perl/CPAN-Mini-0.32
	dev-perl/CPAN-Checksums
	dev-perl/File-Slurp
	dev-perl/yaml"
#	test? ( dev-perl/HTTP-Server-Simple )"
DEPEND="${RDEPEND}"
