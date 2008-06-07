#!bash

source vnmik.configuration

# make vnmik package
# package name
# list of files and other options to z program
#
makepkg()
{
	stat_log "creating package: $*"
	cd $PREFIX
	local pkg="$1"
	local dest="$PREFIX/vnmik.makepkg/$pkg$PKG_SUFFIX"
	shift
	local script=$PKGDIR/z.$pkg
	if [ ! -f $script ]; then
		stat_log "cannot find script file"
		script=
	fi
	z a $dest $script $@ >> $LOGFILE
}

makepkg_all()
{
	makepkg tex.bin "tex.bin/*"
	makepkg tex.var "tex.var/*"
	makepkg tex.user "tex.user/*"
	makepkg tex.doc "tex.doc/*"
}
