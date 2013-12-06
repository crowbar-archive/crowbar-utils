BARCLAMPS="/VMs/repos/crowbar1/crowbar/barclamps/"
for x in `ls ${BARCLAMPS}`; do
	echo BARCLAMP: ${BARCLAMPS}/${x}
	cd ${BARCLAMPS}/${x}
	git --no-pager log --pretty=oneline --no-merges release/pebbles/master..release/mesa-1.6/master 2>/dev/null || echo $? Nothing
	echo
done
