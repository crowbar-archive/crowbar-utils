#!/bin/bash
BARCLAMPS="/VMs/repos/crowbar1/crowbar/barclamps/"
for x in `ls ${BARCLAMPS}`; do
        echo BARCLAMP: ${BARCLAMPS}/${x}
        cd ${BARCLAMPS}/${x}
        echo "$(git --no-pager log --pretty=oneline --no-merges release/roxy/master..release/mesa-1.6/master 2>/dev/null | wc -l) commits outstanding in ${x}"
        git --no-pager log --pretty=oneline --no-merges release/roxy/master..release/mesa-1.6/master 2>/dev/null
        echo
done

