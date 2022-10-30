# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-vm-2

DESCRIPTION="Liberica JDK Full 8u352+8"
HOMEPAGE="https://bell-sw.com"
SRC_URI="https://download.bell-sw.com/java/8u352+8/bellsoft-jdk8u352+8-linux-amd64-full.tar.gz"

LICENSE="GPL-2"
SLOT="8"
KEYWORDS="~* ~amd64"
MY_PV=$(ver_rs 1 'u' 2 '-' ${PV//p/b})

RDEPEND=">=sys-apps/baselayout-java-0.1.0-r1"

RESTRICT="preserve-libs strip"
QA_PREBUILT=""

S="${WORKDIR}/jdk${MY_PV}-full"

src_unpack() {
	default
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}/${dest#/}"

	rm ASSEMBLY_EXCEPTION LICENSE THIRD_PARTY_README || die

	rm -v src.zip || die

	rm -v jre/lib/security/cacerts || die
	dosym ../../../../../etc/ssl/certs/java/cacerts \
		"${dest}"/jre/lib/security/cacerts

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	dosym "${P}" "/opt/${PN}-${SLOT}"

	java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}
