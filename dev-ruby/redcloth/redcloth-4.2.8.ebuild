# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/redcloth/redcloth-4.2.8.ebuild,v 1.3 2011/10/08 14:52:39 graaff Exp $

EAPI=4

# jruby → tests still fail with UTF-8 characters
# http://jgarber.lighthouseapp.com/projects/13054/tickets/149-redcloth-4-doesnt-support-multi-bytes-content
USE_RUBY="ruby18 ree18 ruby19"

RUBY_FAKEGEM_NAME="RedCloth"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.rdoc CHANGELOG"

RUBY_FAKEGEM_REQUIRE_PATHS="lib/case_sensitive_require"

inherit ruby-fakegem versionator

DESCRIPTION="A module for using Textile in Ruby"
HOMEPAGE="http://redcloth.org/"

GITHUB_USER=jgarber
SRC_URI="https://github.com/${GITHUB_USER}/redcloth/tarball/v${PV} -> ${RUBY_FAKEGEM_NAME}-git-${PV}.tgz"
RUBY_S="${GITHUB_USER}-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="$DEPEND
	dev-util/ragel"
RDEPEND="$RDEPEND"

ruby_add_bdepend "
	>=dev-ruby/rake-0.8.7
	>=dev-ruby/rake-compiler-0.7.1
	test? (
		>=dev-ruby/rspec-2.4
		>=dev-ruby/diff-lcs-1.1.2
	)"

pkg_setup() {
	ruby-ng_pkg_setup

	# Export the VERBOSE variable to avoid remapping of stdout and
	# stderr, and that breaks because of bad interactions between
	# echoe, Ruby and Gentoo.
	export VERBOSE=1
}

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile ${PN}.gemspec || die
	rm tasks/{release,gems,rspec}.rake || die
}

each_ruby_compile() {
	# We cannot run this manually easily, because Ragel re-generation
	# is a mess
	${RUBY} -S rake compile || die "rake compile failed"
}

each_ruby_test() {
	${RUBY} -I lib -S rspec spec || die
}
