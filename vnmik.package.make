#!bash

export ROOTDIR=/cygdrive/c/data/vnmik
export ROOTDIR=$PREFIX

# make vnmik package
# package name
# list of files and other options to z program
#
makepkg_core()
{
	stat_msg "creating package: $*"
	local pkg="`echo $1 | sed -e 's/\./_/g'`"
	shift
	local dest="$ROOTDIR/vnmik.makepkg/$pkg$PKG_SUFFIX"
	local pattern="$*"
	local script=vnmik.log/z.$pkg
	if [ ! -f $ROOTDIR/$script ];
	then
		stat_log "cannot find script file: $script"
		script=
	fi
	if [ "x$script$pattern" == "x" ];
	then
		stat_warn "both script and pattern is emtpy"
		return 1
	else
		[ -f $dest ] && (stat_log "removing old package $dest"; rm -fv $dest)
		cd $ROOTDIR
		z cfvj $dest $script $pattern | tee -a $LOGFILE
		stat_msg "new package: $dest"
	fi	
}

makepkg()
{
	local texmaker_files="qtcore4.dll qtgui4.dll mingwm10.dll texmaker.exe texmaker.ini"
	local sumatra_pdf_files="spdf.exe"
	case $1 in
	# editors
	"txc")makepkg_core txc "tex.editor/txc*";;
	"texmaker")
		local pattern=""
		for f in $texmaker_files; do
			pattern="tex.bin/$f $pattern"
		done
		makepkg_core texmaker $pattern
	;;
	# test routines
	"test")makepkg_core vnmik_test "tex.doc/test/*.tex";;
	# tex variant and config 
	"var")makepkg_core tex_var "";;
	"config")makepkg_core tex_config "";;
	# binary files
	"bin")
		echo '' > $LOGDIR/tmp
		for f in $texmaker_files; do
			echo "*tex.bin/$f*" >> $LOGDIR/tmp
		done
		makepkg_core tex.bin \
			"tex.bin/*" \
			--exclude-from-file=$LOGDIR/tmp
	;;
	# texmf tree
	"user")makepkg_core tex.user "tex.user/*";;
	"base")makepkg_core tex.base "tex.base/*";;
	# nothing for anything else....?
	*)stat_msg "nothing to do";;
	esac
}

make_md5checksum()
{
	stat_log "creating md5sum files for packages..."
	cd $PKGDIR
	for f in *$PKG_SUFFIX; do
		md5sum $f > $f.md5sum
	done
	cd -
}

make_distro()
{
	cd $ROOTDIR
	local dest="$ROOTDIR/../vnmik4-`date +%Y%m%d`.zip"
	rm -fv $dest
	stat_log "creating vnmik distro: $dest"
	stat_log "start from ROOTDIR=$ROOTDIR"
	zip -0r \
		$dest \
		./bin/ \
		./vnmik.package/*$PKG_SUFFIX \
		./*.bat \
		-x "*svn*"
	cd -
}

stat_log "library loaded: vnmik.package.make"
