# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/darktable/darktable-0.9.3.ebuild,v 1.2 2011/11/14 21:15:51 radhermit Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2 cmake-utils toolchain-funcs

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="http://darktable.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug flickr gnome gphoto2 kde nls opencl openmp +rawspeed +slideshow video_cards_nvidia"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/libxml2:2
	flickr? ( media-libs/flickcurl )
	gnome? (
		gnome-base/gconf
		gnome-base/gnome-keyring
	)
	gnome-base/librsvg:2
	gphoto2? ( media-libs/libgphoto2 )
	kde? ( dev-libs/dbus-glib )
	media-gfx/exiv2[xmp]
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.3
	media-libs/libpng
	>=media-libs/libraw-0.13.4[demosaic]
	media-libs/openexr
	media-libs/tiff
	net-misc/curl
	opencl? ( video_cards_nvidia? (
		x11-drivers/nvidia-drivers
		>=dev-util/nvidia-cuda-toolkit-3.1
	) )
	slideshow? (
		media-libs/libsdl
		virtual/opengl
	)
	virtual/jpeg
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-system-libraw.patch
	"${FILESDIR}"/${P}-no-rawspeed.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-opencl-kernels.patch
)

pkg_setup() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	base_src_prepare
	sed -i -e "s:\(/share/doc/\)darktable:\1${PF}:" \
		-e "s:LICENSE::" doc/CMakeLists.txt || die
}

src_configure() {
	local myconf
	if use gnome ; then
		myconf="-DDONT_INSTALL_GCONF_SCHEMAS=OFF"
	else
		myconf="-DDONT_INSTALL_GCONF_SCHEMAS=ON"
	fi

	if use opencl && use video_cards_nvidia ; then
		myconf+=" -DUSE_OPENCL=ON"
	else
		myconf+=" -DUSE_OPENCL=OFF"
	fi

	use debug && CMAKE_BUILD_TYPE=Debug

	mycmakeargs=(
		$(cmake-utils_use_use flickr FLICKR)
		$(cmake-utils_use_use gnome GCONF_BACKEND)
		$(cmake-utils_use_use gnome GNOME_KEYRING)
		$(cmake-utils_use_use gphoto2 CAMERA_SUPPORT)
		$(cmake-utils_use_use kde KWALLET)
		$(cmake-utils_use_use nls NLS)
		$(cmake-utils_use_use openmp OPENMP)
		$(cmake-utils_use !rawspeed DONT_USE_RAWSPEED)
		$(cmake-utils_use_build slideshow SLIDESHOW)
		${myconf}
		-DINSTALL_IOP_EXPERIMENTAL=ON
		-DINSTALL_IOP_LEGACY=ON
	)
	cmake-utils_src_configure
}

src_install() {
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"
	cmake-utils_src_install
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
}
