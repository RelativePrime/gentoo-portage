# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-1.0.0.ebuild,v 1.1 2011/09/18 04:08:18 naota Exp $

EAPI="2"
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="${DEPEND}
	>=x11-libs/pango-1.2.1
	>=dev-ruby/rcairo-1.2.0"
RDEPEND="${RDEPEND}
	>=x11-libs/pango-1.2.1
	>=dev-ruby/rcairo-1.2.0"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"
