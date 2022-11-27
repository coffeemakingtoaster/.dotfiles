mode=$1
if [ "$mode" = "set" ]; then
	echo 'placing'
	export TRANSLOCATOR_LOCATION=$PWD
elif [ -z "${mode}" ]; then
	if [ -z "${TRANSLOCATOR_LOCATION}" ]; then
		echo 'Translocator has not been placed'
	else
		cd $TRANSLOCATOR_LOCATION
	fi
else
	echo "invalid argument"
fi
