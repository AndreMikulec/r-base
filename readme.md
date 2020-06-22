
# R 4.0.2 for windows `Generic_Debug` and `<CPU optimized>_NoDebug` Versions of Debug/Optimized for C, C++, and Fortran on 32/64 bit Windows
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/AndreMikulec/r-base?branch=master)](https://ci.appveyor.com/project/AndreMikulec/r-base)

# What is This?

This repository builds *modified clones* (think of a Star Wars Clonetrooper) of the Official-Version/Patched-snapshot/Build-of-the-development (OPB) version of R

https://github.com/r-windows/r-base

Changes in  this
repository https://github.com/AndreMikulec/r-base
include different build options

  - debugging flags
  - optimization flags and/or possibly OpenBlas


## AppVeyor R Build Variants

Two exist: `Generic_Debug` and `<CPU optimized>_NoDebug`.


### Generic_Debug Build

The Debug version `Generic_Debug` contains R language debugging symbols.  E.g. if the debug target is Rterm.exe and the package DLL has been loaded, then when debugging the package DLL, the symbols `Rf_error` and `Rf_PrintValue` are available.

See the video:
```
Using gdb to debug R packages with native code
userprimary
```
https://vimeo.com/11937905


### CPU Optimized NoDebug Build

The CPU Optimized version `<CPU optimized>_NoDebug` is built using custom optimization gcc/gfortran flag(s) available in Rtools.
Debugging symbols are `not` included.


# Available Point Releases

One may not be aware of a new release/point_release of R. E.g. a point release is like the following: 4.0.x or 4.1.y.
If so, inform one about it. Email to Andre_Mikulec@Homail.com.
One then should then run the AppVeyor build to create the new release/point_releases.


# Other: Official-Version/Patched-snapshot/Build-of-the-development (OPB) Version of R


### Official Version of R

If one may want the official version of R for windows, then one may go to any one of here: https://cran.r-project.org/bin/windows/base/, https://ftp.opencpu.org/archive/r-release/, or https://github.com/r-windows/r-base/releases.


### Official Patched snapshot version of R

If one may want the Patched snapshot build of R for windows, then one may go here: https://cran.r-project.org/bin/windows/base/rpatched.html.


### Official Build-of-the-development version of R

If one may want the Build of the development version (which will eventually become the next major release) of R for windows, then one may go here: https://cran.r-project.org/bin/windows/base/rdevel.html.


# Differences Here compared to the (just previously mentioned) OPB Version of R

From the OPB version of R for windows in the
repository https://github.com/r-windows/r-base
compared to this
repository https://github.com/AndreMikulec/r-base
differences (in here) follow.



### Multiple build-job R version (r-patched/r-devel) and Debug/Optimization Combinations may be Attempted

This is configured In the
file https://github.com/AndreMikulec/r-base/blob/master/appveyor.yml
```
environment:
  matrix:
    - rsource_url: https://cran.r-project.org/src/base-prerelease/R-latest.tar.gz
      rversion: r-patched / r-devel
      cran: true
      BUILDFLAGS: USE_ATLAS=YES ATLAS_PATH=/mingw$(WIN)/lib/ DEBUG=T
      MARCHMTUNE: / -march=corei7 -mavx -mavx2 -O3 -funroll-loops -ffast-math
      MARCHMTUNENAME: CPU Build Generic / CPU Build CoreI7 with AVX2
      DIST_BUILD: with Debugging Symbols / without Debugging Symbols
      DEPLOYNAME: Generic_Debug / CoreI7_mAVX2_NoDebug
```


### Debug and Optimization Description in the Version Nickname

In the OPB version of R, the version nick name is set in the R mirror
file https://github.com/wch/r-source/blob/trunk/VERSION-NICK
In the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
in the prepare() bash function
added (appended to) the
file https://github.com/wch/r-source/blob/trunk/VERSION-NICK
contents, are the messages `$MARCHMTUNENAME` and `$DIST_BUILD`
```
sed -i "s/\(.*\)/\1 $MARCHMTUNENAME $DIST_BUILD/" VERSION-NICK
```


### Debugging Symbols for R packages (G_FLAG) and R (DEBUGFLAG)

Because 64-bit Windows does not support dwarf-*, in the
file https://github.com/AndreMikulec/r-base/blob/master/MkRules.local.in
adding and using
```
ifdef DEBUG
  G_FLAG =
endif
```
and in the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
adding and using
```
if ! test "0" = "`grep -c -e "^\s*G_FLAG\s*?\?+\?=\s*" ${srcdir}/MkRules.local.in`"
then
  sed -i "s/^\s*G_FLAG\s*?\?+\?=.*/G_FLAG = -ggdb -Og/" ${srcdir}/MkRules.local.in
else
  echo "G_FLAG = -ggdb -Og" >> ${srcdir}/MkRules.local.in
fi
```
sets (overrides) is the (self declared) variable G_FLAG in the
file https://github.com/AndreMikulec/r-base/blob/master/MkRules.local.in

Because 64-bit Windows does not support dwarf-*, in the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
adding and using
```
if ! test "0" = "`grep -c -e "^\s*DEBUGFLAG\s*?\?+\?=\s*" ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf`"
then
  sed -i -e "s/^\s*DEBUGFLAG\s*?\?+\?=.*/DEBUGFLAG = -ggdb -Og/" ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf
else
  echo "DEBUGFLAG = -ggdb -Og" >> ${srcdir}/build32/src/gnuwin32/fixed/etc/Makeconf
fi
```
sets (overrides) is the variable DEBUGFLAG in the
file https://github.com/wch/r-source/blob/trunk/src/gnuwin32/fixed/Makeconf


### Optimization Flags for R and R packages

Because, of the various custom debug/optimization runs of these AppVeyor build-jobs
in the github R mirror
file https://github.com/wch/r-source/blob/trunk/src/gnuwin32/MkRules.rules
in the OPB version of R the variable EOPTS
```
EOPTS ?= -mfpmath=sse -msse2 -mstackrealign
```
is set (if the value does not already exist in the
file https://github.com/AndreMikulec/r-base/blob/master/MkRules.local.in).
However, in the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
to the
file https://github.com/wch/r-source/blob/trunk/src/gnuwin32/MkRules.rules
adding to (appended to) and using the previous EOPTS value, if any, is the `$MARCHMTUNE` value
```
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
```


### OpenBlas for Optimization

In the
file https://github.com/AndreMikulec/r-base/blob/master/full-build.sh
to make some matrix operations faster, OpenBlas may be included.
```
if ! test "0" = `echo $BUILDFLAGS | grep -c -e "\bUSE_ATLAS=YES\b"`
then
  pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-openblas
fi
```
In the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
the ATLAS flags are begin replaced by the OpenBlas flag.
```
if ! test "0" = "`grep -c -e "-lf77blas -latlas\b" ${srcdir}/build32/src/extra/blas/Makefile.win`"
then
  sed -i "s/-lf77blas -latlas\b/-lopenblas/" ${srcdir}/build32/src/extra/blas/Makefile.win
fi
```


### Debug Builds and Optimization Builds

In the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
to make build-jobs process flexible, changed, is from
```
make 32-bit
```
to
```
make 32-bit $BUILDFLAGS
```
meaning (for example could be)
*make 32-bit DEBUG=T* or *make 32-bit*

In the
file https://github.com/AndreMikulec/r-base/blob/master/PKGBUILD
changed, is from
```
make distribution
```
to
```
make distribution $BUILDFLAGS
```
meaning (for example could be)
*make distribution DEBUG=T* or *make distribution*


### No Code Signing

In the OPB version of R, the
file https://github.com/r-windows/r-base/blob/master/appveyor.yml
has a signing area.
```
Start-FileDownload $env:PfxUri -FileName $env:KeyFile
SignFiles "${env:target}-win.exe"
```
Removed in this repository is the signing section. The URL PfxUri is not available.


### R Checks are Skipped

The *checks* are *not performed.*  These tests would/may cause any Appveyor build-job to use
over one hour of allowed Appveyor build-job allowed time. In the
file https://github.com/r-windows/r-base/blob/master/full-build.sh
```
MINGW_INSTALLS="mingw64" makepkg-mingw 2>&1 | tee r-devel.log
```
the checks are done by default.
However, in the
file https://github.com/AndreMikulec/r-base/blob/master/full-build.sh
```
MINGW_INSTALLS="mingw64" makepkg-mingw --nocheck 2>&1 | tee r-devel.log
```
the checks are explicity not done ( --nocheck ).
However, in the builds of the OPB version of R, the checks had already been done! To see the check results view:
```
https://ftp.opencpu.org/current/check.log
https://ftp.opencpu.org/archive/r-patched/svn_number/check.log
https://ftp.opencpu.org/archive/r-release/R-x.y.z/check.log
```


### QPDF is Installed into R
http://qpdf.sourceforge.net/files/qpdf-manual.html


### AppVeyor Build Deployments of R: `Generic_Debug` and `<CPU optimized>_NoDebug`

Located near the top of the
page https://github.com/AndreMikulec/r-base/releases
one may get deployments from one of the `top` (recent) build-jobs.

The naming format is the following.
```
r-base_<appveyor build iteration>-<master repository>_<rversion>_<target>_<revision>_<DEPLOYNAME>
```
 - rversion is r-patched or r-devel
 - target is R-x.y.zpatched. or R-devel
 - revision is the R SVN revision number
 - DEPLOYNAME describes the build: debug xor optimization

Expand the asset drop down arrow: [v}Asset.  Next, download the file `base_*...*.zip`.  Using an unzip software program, manually extract the R installer executable: R-x.y.z-win.exe. Finally, install R.
