if [ "$(stat -c %d:%i / 2>/dev/null)" != "$(stat -c %d:%i /proc/1/root/. 2>/dev/null)" ]; then
	echo "We are able to execute from within the chroot context."
else
	echo "We are not able to execute from inside a chroot."
	assert_zero 1
fi
