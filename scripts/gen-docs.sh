# Yes, I am entirely aware that this is a hack
srcdir="$(dirname "$0")"
getmods() (
	DOCS=1
	. "$srcdir"/gen-stdlib
	IFS="
"
	for module in $modules; do
		if [ -z "$(echo "$module" | cut -sf1)" ]
		then
			echo "$module"
		else
			module="$(echo "$module" | cut -sf1)"
			echo $module
		fi
	done
	# Not listed in the stdlib for various reasons:
	echo crypto::keystore
	echo mime
)
modules="$(getmods)"

mkdir -p docs/html/

"$BINOUT"/haredoc -Fhtml > docs/html/index.html
for mod in $modules format encoding math crypto hare rt
do
	echo $mod
	path="$(echo $mod | sed -e 's?::?/?g')"
	mkdir -p docs/html/$path
	"$BINOUT"/haredoc -Fhtml $mod > docs/html/$path/index.html
done
