# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/spruz/spruz-0.2.7.ebuild,v 1.1 2011/05/29 07:09:57 graaff Exp $

EAPI=2
USE_RUBY="ruby18 ree18 jruby"

# Should be doc but files are missing from the gem:
# http://github.com/flori/spruz/issues/issue/2
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="All the stuff that isn't good enough for a real library."
HOMEPAGE="http://github.com/flori/spruz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( virtual/ruby-test-unit ) "
