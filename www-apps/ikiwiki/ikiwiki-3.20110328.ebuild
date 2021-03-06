# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/ikiwiki/ikiwiki-3.20110328.ebuild,v 1.1 2011/03/29 06:56:48 tove Exp $

EAPI=3

inherit perl-module

DESCRIPTION="A wiki compiler"
HOMEPAGE="http://ikiwiki.info/"
SRC_URI="mirror://debian/pool/main/i/ikiwiki/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="extras minimal test"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}

#Authen::Passphrase
#Search::Xapian
#Locale::gettext
#Crypt::SSLeay
#Text::CSV
#Text::Typography
#Text::Textile
#Text::WikiFormat
#Net::Amazon::S3

EXTRA_RDEPEND="
	dev-python/docutils
	dev-perl/Digest-SHA1
	dev-perl/File-MimeInfo
	dev-perl/RPC-XML
	dev-perl/XML-Feed
	dev-perl/LWPx-ParanoidAgent
	dev-perl/Net-OpenID-Consumer"

SUGGESTED_RDEPEND="virtual/perl-CGI
	>=dev-perl/CGI-FormBuilder-3.0202
	>=dev-perl/CGI-Session-4.14
	dev-perl/Mail-Sendmail
	dev-perl/Term-ReadLine-Gnu
	dev-perl/XML-Simple
	dev-perl/TimeDate"

TEST_DEPEND="dev-perl/File-chdir"

DEPEND=">=dev-lang/perl-5.10
	app-text/po4a
	dev-perl/HTML-Parser
	dev-perl/HTML-Scrubber
	dev-perl/HTML-Template
	dev-perl/URI
	dev-perl/Text-Markdown
	dev-perl/yaml
"

RDEPEND="${DEPEND}
	!minimal? ( ${SUGGESTED_RDEPEND}
		extras? ( ${EXTRA_RDEPEND} ) )"

DEPEND="${DEPEND}
	test? ( ${TEST_DEPEND} )"

SRC_TEST=do

src_prepare() {
	sed -i 's,lib/ikiwiki,libexec/ikiwiki,' \
		"${S}"/{IkiWiki.pm,Makefile.PL,doc/plugins/install.mdwn} || die
#	if use w3m ; then
		sed -i 's,lib/w3m,libexec/w3m,' "${S}"/Makefile.PL || die
#	else
#		sed -i '/w3m/d' "${S}"/Makefile.PL || die
#	fi
}

src_install() {
	emake DESTDIR="${D}" pure_install || die "make install failed"
	insinto /etc/ikiwiki
	doins wikilist || die

	#insinto /usr/share/doc/${PF}/examples
	#doins -r doc/examples/* || die
	dohtml -r -A setup html/* || die
	dodoc debian/{NEWS,changelog} || die
}
