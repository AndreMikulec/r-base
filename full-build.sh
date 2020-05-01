#!/usr/bin/env bash
cd "$(dirname "$0")"

# Cleanup
rm -rf src pkg

# Update system
pacman -Syyu --noconfirm
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{gcc,gcc-fortran}
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{icu,libtiff,libjpeg,libpng,pcre2,xz,bzip2,zlib}
pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-{cairo,tk,curl}

# Users who do not need it . . . call makepkg with --nocheck flag
# https://wiki.archlinux.org/index.php/Creating_packages#check()
# ANDRE --nocheck
#
# Build package (only once)
set -o pipefail
MINGW_INSTALLS="mingw64" makepkg-mingw --nocheck 2>&1 | tee r-devel.log

# Copy installer to root directory
cp -f src/R-source/src/gnuwin32/installer/*.exe .
