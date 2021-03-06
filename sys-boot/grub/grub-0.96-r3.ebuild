# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/grub/grub-0.96-r3.ebuild,v 1.5 2011/04/10 14:34:42 ulm Exp $

inherit mount-boot eutils flag-o-matic toolchain-funcs

PATCHVER=1.0
DESCRIPTION="GNU GRUB boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
	http://dev.gentoo.org/~seemant/distfiles/${P}-patches-${PATCHVER}.tar.bz2
	http://dev.gentoo.org/~seemant/distfiles/splash.xpm.gz
	mirror://gentoo/splash.xpm.gz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static netboot custom-cflags"

RDEPEND=">=sys-libs/ncurses-5.2-r5"
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.7
	>=sys-devel/autoconf-2.5"

pkg_setup() {
	if use amd64 ; then
		if ! has_m32 ; then
			eerror "Your compiler seems to be unable to compile 32bit code."
			eerror "If you are on amd64, make sure you compile gcc with:"
			echo
			eerror "    USE=multilib FEATURES=-sandbox"
			die "Cannot produce 32bit objects!"
		fi

		ABI_ALLOW="x86"
		ABI="x86"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch"
	epatch "${WORKDIR}"/patch

	# a bunch of patches apply to raw autotool files
	autoconf || die "autoconf failed"
	aclocal || die "aclocal failed"
	automake || die "automake failed"
}

src_compile() {
	unset BLOCK_SIZE #73499

	### i686-specific code in the boot loader is a bad idea; disabling to ensure
	### at least some compatibility if the hard drive is moved to an older or
	### incompatible system.

	# grub-0.95 added -fno-stack-protector detection, to disable ssp for stage2,
	# but the objcopy's (faulty) test fails if -fstack-protector is default.
	# create a cache telling configure that objcopy is ok, and add -C to econf
	# to make use of the cache.
	#
	# CFLAGS has to be undefined running econf, else -fno-stack-protector detection fails.
	# STAGE2_CFLAGS is not allowed to be used on emake command-line, it overwrites
	# -fno-stack-protector detected by configure, removed from netboot's emake.
	use custom-cflags || unset CFLAGS

	export grub_cv_prog_objcopy_absolute=yes #79734
	use static && append-ldflags -static

	# build the net-bootable grub first, but only if "netboot" is set
	if use netboot ; then
		econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		--enable-diskless \
		--enable-{3c{5{03,07,09,29,95},90x},cs89x0,davicom,depca,eepro{,100}} \
		--enable-{epic100,exos205,ni5210,lance,ne2100,ni{50,65}10,natsemi} \
		--enable-{ne,ns8390,wd,otulip,rtl8139,sis900,sk-g16,smc9000,tiara} \
		--enable-{tulip,via-rhine,w89c840} || die "netboot econf failed"

		emake w89c840_o_CFLAGS="-O" || die "making netboot stuff"

		mv -f stage2/{nbgrub,pxegrub} "${S}"/
		mv -f stage2/stage2 stage2/stage2.netboot

		make clean || die "make clean failed"
	fi

	# Now build the regular grub
	# Note that FFS and UFS2 support are broken for now - stage1_5 files too big
	econf \
		--libdir=/lib \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt || die "econf failed"
	emake || die "making regular stuff"
}

src_test() {
	# non-default block size also give false pass/fails.
	unset BLOCK_SIZE
	make check || die "make check failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	exeinto /usr/lib/grub/${CHOST}
	use netboot && doexe nbgrub pxegrub stage2/stage2.netboot

	insinto /boot/grub
	doins "${DISTDIR}"/splash.xpm.gz
	newins docs/menu.lst grub.conf.sample

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample

	docinto gentoo
	dodoc "${PATCHDIR}"/README*
}

pkg_postinst() {
	[[ "${ROOT}" != "/" ]] && return 0

	# change menu.lst to grub.conf
	if [[ ! -e /boot/grub/grub.conf && -e /boot/grub/menu.lst ]] ; then
		mv -f /boot/grub/menu.lst /boot/grub/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi
	einfo "Linking from new grub.conf name to menu.lst"
	[[ ! -e /boot/grub/menu.lst ]] && ln -snf grub.conf /boot/grub/menu.lst

	[[ -e /boot/grub/stage2 ]] && mv /boot/grub/stage2{,.old}

	einfo "Copying files from /lib/grub and /usr/lib/grub to /boot"
	for x in /lib/grub/*/* /usr/lib/grub/*/* ; do
		[[ -f "${x}" ]] && cp -p "${x}" /boot/grub
	done

	[[ -e /boot/grub/grub.conf ]] \
		&& /sbin/grub \
			--batch \
			--device-map=/boot/grub/device.map \
			< /boot/grub/grub.conf > /dev/null 2>&1
}
