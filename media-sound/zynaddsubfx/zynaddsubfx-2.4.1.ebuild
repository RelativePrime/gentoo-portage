# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/zynaddsubfx/zynaddsubfx-2.4.1.ebuild,v 1.2 2011/03/20 20:06:18 jlec Exp $

EAPI=4
inherit eutils cmake-utils

MY_P=ZynAddSubFX-${PV}

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="alsa +fltk jack lash"

RDEPEND="
	sci-libs/fftw:3.0
	fltk? ( x11-libs/fltk:1 )
	jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )
	lash? ( media-sound/lash )
	>=dev-libs/mini-xml-2.2.1"
#	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
# Upstream uses the following preferences: alsa > jack > portaudio
# At least one of them must be enabled
# We do not support portaudio, so if alsa is disabled force jack.
REQUIRED_USE="!alsa? ( jack )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-fltk.patch"
	"${FILESDIR}/${P}-fltk13.patch"
	"${FILESDIR}/${P}-docs.patch"
)

DOCS="ChangeLog FAQ.txt HISTORY.txt README.txt ZynAddSubFX.lsm bugs.txt"

src_configure() {
	use lash || sed -i -e 's/lash-1.0/lash_disabled/' "${S}/src/CMakeLists.txt"
	mycmakeargs=(
		`use fltk && echo "-DGuiModule=fltk" || echo "-DGuiModule=off"`
		`use alsa && echo "-DOutputModule=alsa" || echo "-DOutputModule=jack"`
		`use alsa && echo "-DAlsaMidiOutput=TRUE" || echo "-DAlsaMidiOutput=FALSE"`
		`use jack && echo "-DJackOutput=TRUE" || echo "-DJackOutput=FALSE"`
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	insinto "/usr/share/${PN}"
	doins -r "${S}/banks" "${S}/examples" || die
}
