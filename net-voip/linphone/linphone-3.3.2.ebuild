# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/linphone/linphone-3.3.2.ebuild,v 1.6 2011/11/06 12:47:49 grobian Exp $

EAPI="3"

inherit eutils autotools multilib versionator

DESCRIPTION="Video softphone based on the SIP protocol"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://download.savannah.nongnu.org/releases-noredirect/${PN}/$(get_version_component_range 1-2).x/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-macos"
IUSE="doc gtk ipv6 ncurses nls video"

RDEPEND=">=media-libs/mediastreamer-2.6.0[video?]
	>=net-libs/libeXosip-3.0.2
	>=net-libs/libosip-3.0.0
	>=net-libs/ortp-0.16.2
	gtk? ( dev-libs/glib:2
		>=gnome-base/libglade-2.4.0:2.0
		>=x11-libs/gtk+-2.4.0:2 )
	ncurses? ( sys-libs/readline
		sys-libs/ncurses )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-text/sgmltools-lite )
	nls? ( dev-util/intltool
		sys-devel/gettext )"

IUSE_LINGUAS=" fr it de ja es pl cs nl sv pt_BR hu ru zh_CN"
IUSE="${IUSE} ${IUSE_LINGUAS// / linguas_}"

# TODO:
# update ortp ?
# update mediastreamer ?

# TODO:
# run-time test for ipv6 : does it need mediastreamer[ipv6] ?

pkg_setup() {
	if ! use gtk && ! use ncurses ; then
		ewarn "gtk and ncurses are disabled."
		ewarn "At least one of these use flags are needed to get a front-end."
		ewarn "Only liblinphone is going to be installed."
	fi

	strip-linguas ${IUSE_LINGUAS}
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.2.99.1-external-mediastreamer.patch
	epatch "${FILESDIR}"/${PN}-3.2.1-nls.patch

	# remove speex check, avoid bug when mediastreamer[-speex]
	sed -i -e '/SPEEX/d' configure.in || die "patching configure.in failed"

	# fix path to use lib64
	sed -i -e "s:lib\(/liblinphone\):$(get_libdir)\1:" configure.in \
		|| die "patching configure.in failed"

	# removing bundled libs dir prevent them to be reconf
	rm -rf mediastreamer2 oRTP || die "should not die"
	# and references in Makefile.am
	sed -i -e "s:oRTP::;s:mediastreamer2::" Makefile.am \
		|| die "patching Makefile.am failed"

	# don't know why, but exosip macro references a non-existing framework
	sed -i -e "s/-framework CFNetwork//" m4/exosip.m4 \
		|| die "patching m4/exosip.m4 failed"

	# make sure to use host libtool version
	rm -f m4/libtool.m4 m4/lt*.m4 #282268
	eautoreconf
}

src_configure() {
	# strict: we don't want -Werror
	# external-ortp,external-mediastreamer: prefer external libs
	# truespeech: seems not used, TODO: ask in ml
	# rsvp: breaking the build (not maintained anymore) --disable = --enable
	# alsa, artsc and portaudio are used for bundled mediastreamer
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-strict \
		--enable-external-ortp \
		--enable-external-mediastreamer \
		--disable-truespeech \
		--disable-dependency-tracking \
		$(use_enable doc manual) \
		$(use_enable gtk gtk_ui) \
		$(use_enable ipv6) \
		$(use_enable ncurses console_ui) \
		$(use_enable nls) \
		$(use_enable video)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dosym linphone-3 /usr/bin/linphone || die
	dodoc AUTHORS BUGS ChangeLog NEWS README README.arm TODO || die
	#cp "${ED}/usr/share/pixmaps/"{linphone/linphone2.png,linphone2.png} || die
}
