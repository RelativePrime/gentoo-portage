# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/fetchmail/fetchmail-6.3.21.ebuild,v 1.7 2011/11/06 20:13:45 eras Exp $

EAPI=3

PYTHON_DEPEND="tk? 2"
PYTHON_USE_WITH_OPT="tk"
PYTHON_USE_WITH="tk"

inherit python eutils autotools

DESCRIPTION="the legendary remote-mail retrieval and forwarding utility"
HOMEPAGE="http://fetchmail.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ssl nls kerberos hesiod tk socks"

RDEPEND="hesiod? ( net-dns/hesiod )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	kerberos? ( virtual/krb5 >=dev-libs/openssl-0.9.6 )
	nls? ( virtual/libintl )
	elibc_FreeBSD? ( sys-libs/e2fsprogs-libs )
	socks? ( net-proxy/dante )"
DEPEND="${RDEPEND}
	sys-devel/flex
	nls? ( sys-devel/gettext )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	if use tk; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-gss_c_nt_hostbased_service.patch"
	eautoreconf
	# dont compile during src_install
	: > "${S}"/py-compile
}

src_configure() {
	if use tk ; then
		export PYTHON=$(PYTHON -a )
	else
		export PYTHON=:
	fi
	econf \
		--enable-RPA \
		--enable-NTLM \
		--enable-SDPS \
		$(use_enable nls) \
		$(use_with ssl) \
		$(use kerberos && echo "--with-ssl" ) \
		$(use_with kerberos gssapi) \
		$(use_with kerberos kerberos5) \
		$(use_with hesiod) \
		$(use_with socks)
}

src_install() {
	# fetchmail's homedir (holds fetchmail's .fetchids)
	keepdir /var/lib/${PN} || die
	fowners ${PN}:${PN} /var/lib/${PN} || die
	fperms 700 /var/lib/${PN} || die

	emake DESTDIR="${D}" install || die

	dohtml *.html

	dodoc FAQ FEATURES NEWS NOTES README README.NTLM README.SSL* TODO || die

	newinitd "${FILESDIR}"/fetchmail.initd fetchmail || die
	newconfd "${FILESDIR}"/fetchmail.confd fetchmail || die

	docinto contrib
	local f
	for f in contrib/* ; do
		[ -f "${f}" ] && dodoc "${f}"
	done
}

pkg_postinst() {
	use tk && python_mod_optimize fetchmailconf.py

	elog "Please see /etc/conf.d/fetchmail if you want to adjust"
	elog "the polling delay used by the fetchmail init script."
}

pkg_postrm() {
	use tk && python_mod_cleanup fetchmailconf.py
}
