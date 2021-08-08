set -a

assert_zero() {
	if [[ "$1" -eq 0 ]]; then 
		return
	else
		exit $1
	fi
}

assert_nonzero() {
	if [[ "$1" -eq 0 ]]; then 
		exit 0
	else
		return
	fi
}
