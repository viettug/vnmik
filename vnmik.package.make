#!bash

# make vnmik package
# package name
# list of files and other options to z program
#
makepkg()
{
	stat_log "creating package: $*"
	if [ "x$2" == "x" ]; then
		stat_warn "($FUNCNAME) missing paramemeter"
		return 1
	fi
	cd $PREFIX
	local pkg="`echo $1 | sed -e 's/\./_/g'`"
	local dest="$PREFIX/vnmik.makepkg/$pkg$PKG_SUFFIX"
	shift
	local script=vnmik.log/z.$pkg
	if [ ! -f $PREFIX/$script ]; then
		stat_log "cannot find script file: $script"
		script=
	fi
	z a $dest $script $@ # >> $LOGFILE
	stat_log "creating checksum file..."
	md5sum $dest > $dest.md5sum
}

makepkg_all()
{
	for pkg in bin var user doc ; do
		makepkg tex.$pkg "tex.$pkg/*"
	done	
}

stat_log "library loaded: vnmik.package.make"
