# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/libreoffice-bin/libreoffice-bin-3.4.3-r2.ebuild,v 1.1 2011/09/03 21:03:58 scarabeus Exp $

EAPI="3"

inherit eutils fdo-mime gnome2-utils pax-utils prefix rpm multilib

IUSE="gnome java"

MY_PV="${PV/_/-}"
MY_PV2="${PV}rc2"
BVER="3.4.3-302"
BVER2="3.4-302"
BASIS="libobasis3.4"
BASIS2="basis3.4"
NM="libreoffice"
NM1="${NM}"
NM2="${NM1}3.4"
FILEPATH="http://download.documentfoundation.org/${NM}/stable/${PV}/rpm/"
if [ "${ARCH}" = "amd64" ] ; then
	XARCH="x86_64"
	PACKED="LibO_${MY_PV2}_Linux_x86-64"
else
	XARCH="i586"
	PACKED="LibO_${MY_PV2}_Linux_x86"
fi
UP="${PACKED}_install-rpm_en-US/RPMS"

DESCRIPTION="LibreOffice productivity suite."
HOMEPAGE="http://www.libreoffice.org"
SRC_URI="amd64? ( ${FILEPATH}/x86_64/LibO_${PV}_Linux_x86-64_install-rpm_en-US.tar.gz )
	x86? ( ${FILEPATH}/x86/LibO_${PV}_Linux_x86_install-rpm_en-US.tar.gz )"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="!app-office/libreoffice
	!app-office/openoffice
	!app-office/openoffice-bin
	!prefix? ( sys-libs/glibc )
	app-arch/unzip
	app-arch/zip
	>=dev-lang/perl-5.0
	>=media-libs/freetype-2.1.10-r2
	x11-libs/libXaw
	x11-libs/libXinerama"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PDEPEND="
	>=app-office/libreoffice-l10n-${PV}
	java? ( >=virtual/jre-1.5 )
"

RESTRICT="strip"

QA_EXECSTACK="usr/$(get_libdir)/${NM}/${BASIS2}/program/*
	usr/$(get_libdir)/${NM}/ure/lib/*"
QA_TEXTRELS="usr/$(get_libdir)/${NM}/ure/lib/*"
QA_PRESTRIPPED="usr/$(get_libdir)/${NM}/${BASIS2}/program/*
	usr/$(get_libdir)/${NM}/${BASIS2}/program/python-core-2.6.1/lib/lib-dynload/*
	usr/$(get_libdir)/${NM}/program/*
	usr/$(get_libdir)/${NM}/ure/bin/*
	usr/$(get_libdir)/${NM}/ure/lib/*"

src_unpack() {

	unpack ${A}

	cp "${FILESDIR}"/{50-${PN},wrapper.in} "${T}"
	eprefixify "${T}"/{50-${PN},wrapper.in}

	for i in base binfilter calc core01 core02 core03 core04 core05 core06 \
		core07 draw graphicfilter images impress math ogltrans ooofonts \
		ooolinguistic pyuno testtool writer xsltfilter ; do
		rpm_unpack "./${UP}/${BASIS}-${i}-${BVER}.${XARCH}.rpm"
	done

	rpm_unpack "./${UP}/${NM2}-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM2}-ure-${BVER}.${XARCH}.rpm"

	for j in base calc draw impress math writer; do
		rpm_unpack "./${UP}/${NM2}-${j}-${BVER}.${XARCH}.rpm"
	done

	rpm_unpack "./${UP}/desktop-integration/${NM2}-freedesktop-menus-${BVER2}.noarch.rpm"

	use gnome && rpm_unpack "./${UP}/${BASIS}-gnome-integration-${BVER}.${XARCH}.rpm"
	use java && rpm_unpack "./${UP}/${BASIS}-javafilter-${BVER}.${XARCH}.rpm"

	# Extensions
	for k in beanshell-script-provider javascript-script-provider mediawiki-publisher nlpsolver pdf-import presentation-minimizer presenter-screen python-script-provider report-builder; do
		rpm_unpack "./${UP}/${BASIS}-extension-${k}-${BVER}.${XARCH}.rpm"
	done

	# English support installed by default
	rpm_unpack "./${UP}/${BASIS}-en-US-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM2}-en-US-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM2}-dict-en-${BVER}.${XARCH}.rpm"
	for s in base binfilter calc math res writer ; do
		rpm_unpack "./${UP}/${BASIS}-en-US-${s}-${BVER}.${XARCH}.rpm"
	done

}

src_install () {

	INSTDIR="/usr/$(get_libdir)/${NM}"
	dodir ${INSTDIR}
	mv "${WORKDIR}"/opt/${NM2}/* "${ED}${INSTDIR}" || die

	#Menu entries, icons and mime-types
	cd "${ED}${INSTDIR}/share/xdg/"
	for desk in base calc draw impress javafilter math printeradmin qstart startcenter writer; do
		if [ "${desk}" = "javafilter" ] ; then
			use java || { rm -f javafilter.desktop; continue; }
		fi
		mv ${desk}.desktop ${NM1}-${desk}.desktop
		sed -i -e s/${NM2}/${NM}/g ${NM1}-${desk}.desktop || die
		domenu ${NM1}-${desk}.desktop
	done
	insinto /usr/share
	doins -r "${WORKDIR}"/usr/share/icons
	doins -r "${WORKDIR}"/usr/share/mime

	# Install wrapper script
	newbin "${T}/wrapper.in" ${NM1}
	sed -i -e s/LIBDIR/$(get_libdir)/g "${ED}/usr/bin/${NM1}" || die

	dosym ${INSTDIR}/program/spadmin /usr/bin/${NM1}-printeradmin

	rm -f "${ED}${INSTDIR}/basis-link" || die
	dosym ${INSTDIR}/${BASIS2} ${INSTDIR}/basis-link

	# Non-java weirdness see bug #99366
	use !java && rm -f "${ED}${INSTDIR}/ure/bin/javaldx"

	# install the unopkg binary
	dosym ${INSTDIR}/program/unopkg /usr/bin/unopkg

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${T}/50-${PN}"

}

pkg_preinst() {

	use gnome && gnome2_icon_savelist

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gnome && gnome2_icon_cache_update

	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/${NM}/program/soffice.bin

}

pkg_postrm() {

	fdo-mime_desktop_database_update
	use gnome && gnome2_icon_cache_update

}
