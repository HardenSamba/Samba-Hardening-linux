#!/bin/bash
# Construit le paquet secop-hardening.
# Usage : ./build.sh
set -e
cd "$(dirname "$0")"
VERSION=$(awk '/^Version:/{print $2}' secop-hardening/DEBIAN/control)

# Permissions attendues par dpkg
find secop-hardening -type d -exec chmod 755 {} \;
chmod 0755 secop-hardening/DEBIAN/postinst secop-hardening/DEBIAN/prerm \
           secop-hardening/DEBIAN/postrm secop-hardening/usr/sbin/secop-harden
chmod 0644 secop-hardening/DEBIAN/control secop-hardening/DEBIAN/conffiles

bash -n secop-hardening/usr/sbin/secop-harden
for s in postinst prerm postrm; do sh -n "secop-hardening/DEBIAN/$s"; done

dpkg-deb --root-owner-group --build secop-hardening "secop-hardening_${VERSION}_all.deb"
echo "Paquet construit : secop-hardening_${VERSION}_all.deb"
