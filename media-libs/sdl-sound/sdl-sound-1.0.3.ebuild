# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-sound/sdl-sound-1.0.3.ebuild,v 1.6 2010/07/27 00:33:06 mr_bones_ Exp $

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="A library that handles the decoding of sound file formats"
HOMEPAGE="http://icculus.org/SDL_sound/"
SRC_URI="http://icculus.org/SDL_sound/downloads/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="flac mikmod mp3 mpeg physfs speex static-libs vorbis"

RDEPEND=">=media-libs/libsdl-1.2
	flac? ( media-libs/flac )
	mikmod? ( >=media-libs/libmikmod-3.1.9 media-libs/libmodplug )
	vorbis? ( >=media-libs/libvorbis-1.0_beta4 )
	speex? ( media-libs/speex media-libs/libogg )
	physfs? ( dev-games/physfs )
	mpeg? ( media-libs/smpeg )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--disable-dependency-tracking \
		--enable-midi \
		$(use_enable mpeg smpeg) \
		$(use_enable mp3 mpglib) \
		$(use_enable flac) \
		$(use_enable speex) \
		$(use_enable static-libs static) \
		$(use_enable mikmod) \
		$(use_enable mikmod modplug) \
		$(use_enable physfs) \
		$(use_enable vorbis ogg) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc CHANGELOG CREDITS README TODO
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -exec rm {} + \
			|| die "la removal failed"
	fi
}
