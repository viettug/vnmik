#!bash

# make vnmik package
# package name
# list of files and other options to z program
#
makepkg_core()
{
	stat_log "creating package: $*"
	if [ "x$2" == "x" ]; then
		stat_warn "($FUNCNAME) missing paramemeter"
		return 1
	fi
	local pkg="`echo $1 | sed -e 's/\./_/g'`"
	local dest="$PREFIX/vnmik.makepkg/$pkg$PKG_SUFFIX"
	local pattern="$2"
	local script=vnmik.log/z.$pkg
	if [ ! -f $PREFIX/$script ]; then
		stat_log "cannot find script file: $script"
		script=
	fi
	[ -f $dest ] && (stat_log "removing old package $dest"; rm -fv $dest)
	cd $PREFIX
	z cfvj $dest $script $pattern | tee -a $LOGFILE
	stat_log "creating checksum file..."
	md5sum $dest > $dest.md5sum
}

makepkg_spec()
{
	for pkg in $*; do
		makepkg_core tex.$pkg "tex.$pkg/*"
	done
}

makepkg()
{
	case $1 in
	"txc")makepkg_core txc "tex.editor/txc*";;
	"texmaker")makepkg_core texmaker "tex.editor/texmaker/*";;
	*)makepkg_space $*;;
	esac
}


stat_log "library loaded: vnmik.package.make"
