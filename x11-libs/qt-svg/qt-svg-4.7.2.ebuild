# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-svg/qt-svg-4.7.2.ebuild,v 1.6 2011/07/13 12:54:22 xarthisius Exp $

EAPI="3"
inherit qt4-build

DESCRIPTION="The SVG module for the Qt toolkit"
SLOT="4"
KEYWORDS="amd64 arm ~hppa ~ia64 ~mips ppc ppc64 -sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="+accessibility iconv"

DEPEND="~x11-libs/qt-gui-${PV}[accessibility=,aqua=,debug=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/svg
		src/plugins/imageformats/svg
		src/plugins/iconengines/svgiconengine"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		include/QtSvg/
		include/Qt/
		include/QtGui/
		include/QtCore/
		include/QtXml/
		src/corelib/
		src/gui/
		src/plugins/
		src/xml
		src/3rdparty"

	QCONFIG_ADD="svg"
	QCONFIG_DEFINE="QT_SVG"

	qt4-build_pkg_setup
}

src_configure() {
	myconf="${myconf} -svg
		$(qt_use iconv)
		$(qt_use accessibility)
		-no-xkb  -no-xrender
		-no-xrandr -no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm
		-no-opengl -no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff
		-no-fontconfig -no-glib -no-gtkstyle"
	qt4-build_src_configure
}
