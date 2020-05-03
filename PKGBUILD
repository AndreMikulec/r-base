# Maintainer: Jeroen Ooms <jeroen@berkeley.edu>

_realname=r-installer
pkgbase=${_realname}
pkgname="${_realname}"
pkgver=4.0.9000
pkgrel=1
pkgdesc="The R Programming Language"
arch=('any')
makedepends=("${MINGW_PACKAGE_PREFIX}-bzip2"
             "${MINGW_PACKAGE_PREFIX}-gcc"
             "${MINGW_PACKAGE_PREFIX}-gcc-fortran"
             "${MINGW_PACKAGE_PREFIX}-cairo"
             "${MINGW_PACKAGE_PREFIX}-curl"
             "${MINGW_PACKAGE_PREFIX}-icu"
             "${MINGW_PACKAGE_PREFIX}-libtiff"
             "${MINGW_PACKAGE_PREFIX}-libjpeg"
             "${MINGW_PACKAGE_PREFIX}-libpng"
             "${MINGW_PACKAGE_PREFIX}-pcre2"
             "${MINGW_PACKAGE_PREFIX}-tcl"
             "${MINGW_PACKAGE_PREFIX}-tk"
             "${MINGW_PACKAGE_PREFIX}-xz"
             "${MINGW_PACKAGE_PREFIX}-zlib"
             "texinfo"
             "texinfo-tex"
             "sed")
options=('staticlibs')
license=("GPL")
url="https://www.r-project.org/"

# Default source is R-devel (override via $rsource_url)
source=(R-source.tar.gz::"${rsource_url:-https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz}"
    https://curl.haxx.se/ca/cacert.pem
    MkRules.local.in
    shortcut.diff
    create-tcltk-bundle.sh)

# Automatic untar fails due to embedded symlinks
noextract=(R-source.tar.gz)

sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

prepare() {
  # Verify that InnoSetup is installed
  INNOSETUP="C:/Program Files (x86)/Inno Setup 6/ISCC.exe"
  msg2 "Testing for $INNOSETUP"
  test -f "$INNOSETUP"
  "$INNOSETUP" 2>/dev/null || true

  # Put pdflatex on the path (assume Miktex 2.9)
  msg2 "Checking if pdflatex and texindex can be found..."
  export PATH="$PATH:/c/progra~1/MiKTeX 2.9/miktex/bin/x64"
  pdflatex --version
  texindex --version

  # Extract tarball with symlink workarounds
  msg2 "Extracting R source tarball..."
  rm -rf ${srcdir}/R-source
  mkdir -p ${srcdir}/R-source
  MSYS="winsymlinks:lnk" tar -xf ${srcdir}/R-source.tar.gz -C ${srcdir}/R-source --strip-components=1
  cd "${srcdir}/R-source"

  # Ship the CA bundle
  cp "${srcdir}/cacert.pem" etc/curl-ca-bundle.crt

  # Ship the TclTk runtime bundle
  msg2 "Creating the TclTk runtime bundle"
  mkdir -p Tcl/{bin,bin64,lib,lib64}
  ${srcdir}/create-tcltk-bundle.sh  

  # Add your patches here
  patch -Np1 -i "${srcdir}/shortcut.diff"

  # ANDRE SEE
  # post release cleanups
  # https://github.com/r-windows/r-base/commit/843173da343007abd7147f9217a0ae83f49f9178
  #
  sed -i "s/\(.*\)/\1 $MARCHMTUNENAME $DIST_BUILD/" VERSION-NICK
  echo MARCHMTUNENAME: $MARCHMTUNENAME
  echo     DIST_BUILD: $DIST_BUILD
  echo cat  \`pwd\`/VERSION-NICK
  echo       `pwd`/VERSION-NICK
  cat        `pwd`/VERSION-NICK

}

build() {
  msg2 "Copying source files for 32-bit build..."
  rm -Rf ${srcdir}/build32
  MSYS="winsymlinks:lnk" cp -Rf "${srcdir}/R-source" ${srcdir}/build32

  # ANDRE
  #
  # If the G_FLAG is found
  if ! test "0" = "`grep -c -e "^\s*G_FLAG\s*?\?+\?=\s*" ${srcdir}/MkRules.local.in`"
  then
    sed -i "s/^\s*G_FLAG\s*?\?+\?=.*/G_FLAG = -ggdb -Og/" ${srcdir}/MkRules.local.in
  else
    echo "G_FLAG = -ggdb -Og" >> ${srcdir}/MkRules.local.in
  fi
  echo cat '${srcdir}/MkRules.local.in'
  echo cat "${srcdir}/MkRules.local.in"
  cat       ${srcdir}/MkRules.local.in

  # ANDRE
  # Need to be here. After MkRules.local is processed, then MkRules.rules is processed.
  # However, EOPTS is defined in MkRules.rules and I want to append more flages to EOPTS.
  # Also, to the file, I can not seem to  append a 2nd line.
  #   maybe this is because GNU Make "deferral" just replaces the variable definition ?? 
  #
  # If the EOPTS is found
  # ANDRE
  if ! test "0" = "`grep -c -e "^\s*EOPTS\s*?\?+\?=\s*" ${srcdir}/build32/src/gnuwin32/MkRules.rules`"
  then
    if ! test "-$MARCHMTUNE-" = "--"
    then
      sed -i "s/\(^\s*EOPTS\s*?\?+\?=.*\)/\1 $MARCHMTUNE/" ${srcdir}/build32/src/gnuwin32/MkRules.rules
    fi
  else
    if ! test "-$MARCHMTUNE-" = "--"
    then
      echo "EOPTS += $MARCHMTUNE" >> ${srcdir}/build32/src/gnuwin32/MkRules.rules
    fi
  fi
  #
  echo cat '${srcdir}/build32/src/gnuwin32/MkRules.rules'
  echo cat "${srcdir}/build32/src/gnuwin32/MkRules.rules"
  cat       ${srcdir}/build32/src/gnuwin32/MkRules.rules
  #
  # Sample code (with assigner of "+=" or "?=" "=")
  # Test for the existence of EOPTS
  # ! test "0" = "`grep -c -e "^\s*EOPTS\s*?\?+\?=\s*" ${srcdir}/MkRules.rules`"
  # Replace line
  # sed -i "s/^\s*EOPTS\s*?\?+\?=.*/EOPTS += $MARCHMTUNE/" ${srcdir}/MkRules.rules
  # To the current line, append new data
  #   # https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html
  #   One line file
  #     sed -i "s/\(.*\)/\1 $MARCHMTUNE/g" ${srcdir}/MkRules.rules
  #   Multiline file
  #     sed -e "s/\(^\s*EOPTS\s*?\?+\?=.*\)/\1 $MARCHMTUNE/" MkRules.rules
  # To the file append a new line
  # echo "EOPTS += $MARCHMTUNE" >> ${srcdir}/MkRules.rules

  # ANDRE
  #
  # If the DEBUGFLAG is found
  if ! test "0" = "`grep -c -e "^\s*DEBUGFLAG\s*?\?+\?=\s*" ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf`"
  then
    sed -i -e "s/^\s*DEBUGFLAG\s*?\?+\?=.*/DEBUGFLAG = -ggdb -Og/" ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf
  else
    echo "DEBUGFLAG = -ggdb -Og" >> ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf
  fi
  echo cat '${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf'
  echo cat "${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf"
  cat       ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf


  # Build 32 bit version
  msg2 "Building 32-bit version of base R..."
  cd "${srcdir}/build32/src/gnuwin32"
  sed -e "s|@win@|32|" -e "s|@texindex@||" -e "s|@home32@||" "${srcdir}/MkRules.local.in" > MkRules.local
  #make 32-bit SHELL='sh -x'
  make $MAKE_32BIT
  
  # Build 64 bit + docs and installers
  msg2 "Building 64-bit distribution"
  cd "${srcdir}/R-source/src/gnuwin32"
  TEXINDEX=$(cygpath -m $(which texindex))  
  sed -e "s|@win@|64|" -e "s|@texindex@|${TEXINDEX}|" -e "s|@home32@|${srcdir}/build32|" "${srcdir}/MkRules.local.in" > MkRules.local
  make $MAKE_DISTRIBUTION
}

check(){
  # Use cloud mirror for CRAN unit test
  #export R_CRAN_WEB="https://cran.rstudio.com"

  # Run 64 bit checks in foreground
  cd "${srcdir}/R-source/src/gnuwin32"
  echo "===== 64 bit checks ====="
  make check-all
}

package() {
  # Derive output locations
  REVISION=$((read x; echo ${x:10}) < "${srcdir}/R-source/SVN-REVISION")
  CRANDIR="${srcdir}/R-source/src/gnuwin32/cran"

  # This sets TARGET variable
  $(sed -e 's|set|export|' "${CRANDIR}/target.cmd")

  # Copy CRAN release files
  cp "${srcdir}/R-source/SVN-REVISION" "${pkgdir}/SVN-REVISION.${target}"
  cp "${CRANDIR}/NEWS.${target}.html" ${pkgdir}/
  cp "${CRANDIR}/README.${target}" ${pkgdir}/

  # Determine which webpage variant to ship from target (for example "R-3.4.1beta")
  case "$target" in
  *devel|*testing)
    cp "${CRANDIR}/rdevel.html" "${pkgdir}/"
    ;;
  *patched|*alpha|*beta|*rc)
    cp "${CRANDIR}/rpatched.html" "${pkgdir}/"
    cp "${CRANDIR}/rtest.html" "${pkgdir}/"
    ;;
  R-4*)
    cp "${CRANDIR}/index.html" "${pkgdir}/"
    cp "${CRANDIR}/md5sum.txt" "${pkgdir}/"
    cp "${CRANDIR}/rw-FAQ.html" "${pkgdir}/"
    cp "${CRANDIR}/release.html" "${pkgdir}/"
    REVISION="$target"
    ;;
  *)
    echo "Unknown release type: $target"
    exit 1
    ;;
  esac

  # Helper for appveyor script
  echo "set revision=${REVISION}" >> "${CRANDIR}/target.cmd"
  cp "${CRANDIR}/target.cmd" ${pkgdir}/
}
