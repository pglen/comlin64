
nn=0
if [  $(($1)) -lt 1000 ] ; then
	nn=$1
else
	if [  $(($1)) -lt 1000000 ] ; then
		nn=$(($1/1000)),$(($1%1000))
	fi
fi

echo "number: $nn"
