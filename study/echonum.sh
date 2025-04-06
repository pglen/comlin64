
# Print commas into large numbers up to trillions

nn=0
if [  $(($1)) -lt 1000 ] ; then
	nn=$1
else
	if [  $(($1)) -lt 1000000 ] ; then
		nn=$(($1/1000)),$(($1%1000))
    else
    	if [  $(($1)) -lt 1000000000 ] ; then
    		nn=$(($1/1000000)),$(($1/1000 % 1000)),$(($1%1000))
    	else
            if [  $(($1)) -lt 1000000000000 ] ; then
        		nn=$(($1/1000000000 % 1000)),$(($1/1000000 % 1000)),$(($1/1000%1000)),$(($1%1000))
            else
                nn=$1
            fi
        fi
	fi
fi

echo "number: $nn"
