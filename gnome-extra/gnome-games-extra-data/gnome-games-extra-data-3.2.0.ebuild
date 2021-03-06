# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-games-extra-data/gnome-games-extra-data-3.2.0.ebuild,v 1.1 2011/11/07 04:03:17 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Optional additional graphics for gnome-games"
HOMEPAGE="http://live.gnome.org/GnomeGames/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="!<gnome-extra/gnome-games-3.0.0"
DOCS="AUTHORS ChangeLog NEWS README"
