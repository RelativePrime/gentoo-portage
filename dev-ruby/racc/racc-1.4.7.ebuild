# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/racc/racc-1.4.7.ebuild,v 1.1 2011/10/20 06:09:22 graaff Exp $

EAPI=4

USE_RUBY="ree18 ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc README.ja.rdoc TODO ChangeLog"

inherit multilib ruby-fakegem

DESCRIPTION="A LALR(1) parser generator for Ruby"
HOMEPAGE="http://www.loveruby.net/en/racc.html"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend "dev-ruby/rake"

all_ruby_prepare() {
	# for Ruby 1.9.2 compatibility
	sed -i -e '1i $: << "."' Rakefile || die

	sed -i -e '/tasks\/email/s:^:#:' Rakefile || die "rakefile fix failed"
	sed -i -e 's|/tmp/out|${TMPDIR:-/tmp}/out|' test/helper.rb || die "tests fix failed"
}

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			;;
		*)
			${RUBY} -Cext/racc extconf.rb || die
			;;
	esac
}

each_ruby_compile() {
	case ${RUBY} in
		*jruby)
			einfo "Under JRuby, racc cannot use the shared object parser, so instead"
			einfo "you have to rely on the pure Ruby implementation."
			;;
		*)
			emake -Cext/racc
			# Copy over the file here so that we don't have to do
			# special ruby install for JRuby and the other
			# implementations.
			cp -l ext/racc/cparse$(get_modname) lib/racc/cparse$(get_modname) || die
			;;
	esac
}

each_ruby_test() {
	case ${RUBY} in
		*jruby)
			ewarn "Using JRuby 1.5.2 the tests are currently badly broken,"
			ewarn "so they are disabled until a new racc or a new JRuby is"
			ewarn "released."
			;;
		*)
			each_fakegem_test
			;;
	esac
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r rdoc

	docinto examples
	dodoc -r sample
}
