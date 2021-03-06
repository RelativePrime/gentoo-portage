# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/llpp/llpp-9999.ebuild,v 1.8 2011/10/04 22:46:00 xmw Exp $

EAPI=3

EGIT_REPO_URI="git://repo.or.cz/llpp.git"

inherit git-2 toolchain-funcs

DESCRIPTION="a graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="http://repo.or.cz/w/llpp.git"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="vanilla"

RDEPEND=">=app-text/mupdf-0.8.165
	dev-ml/lablgl[glut]
	dev-lang/ocaml[ocamlopt]
	media-libs/jbig2dec
	media-libs/openjpeg
	x11-misc/xsel"
DEPEND="${RDEPEND}"

src_prepare() {
	use vanilla || epatch "${FILESDIR}"/${PN}-WM_CLASS.patch
}

src_compile() {
	ocaml str.cma keystoml.ml KEYS > help.ml || die
	printf 'let version ="%s";;\n' $(git describe --tags --dirty) >> help.ml || die

	local myccopt="$(freetype-config --cflags) -O -include ft2build.h -D_GNU_SOURCE"
	local mycclib="-lmupdf -lfitz -lz -ljpeg -lopenjpeg -ljbig2dec -lfreetype"
	#if use ocamlopt ; then
		myccopt="${myccopt} -lpthread"
		ocamlopt -c -o link.o -ccopt "${myccopt}" link.c || die
		ocamlopt -c -o help.cmx help.ml || die
		ocamlopt -c -o parser.cmx parser.ml || die
		ocamlopt -c -o main.cmx -I +lablGL main.ml || die
	    ocamlopt -o llpp -I +lablGL \
			str.cmxa unix.cmxa lablgl.cmxa lablglut.cmxa link.o \
		    -cclib "${mycclib}" help.cmx parser.cmx main.cmx || die
	#else
	#	ocamlc -c -o link.o -ccopt "${myccopt}" link.c || die
	#	ocamlc -c -o help.cmo help.ml || die
	#	ocamlc -c -o parser.cmo parser.ml || die
	#	ocamlc -c -o main.cmo -I +lablGL main.ml || die
	#	ocamlc -custom -o llpp -I +lablGL \
	#		str.cma unix.cma lablgl.cma lablglut.cma link.o \
	#		-cclib "${mycclib}" help.cmo parser.cmo main.cmo || die
	#fi
}

src_install() {
	dobin ${PN} || die
	dodoc KEYS README Thanks fixme || die
}
