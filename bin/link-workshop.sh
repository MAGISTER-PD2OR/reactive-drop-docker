#!/bin/bash
set +e

workshopdir="/root/Steam/steamapps/workshop/content/563560"
addonfolder="/root/reactivedrop/reactivedrop/addons"

if [[ -d $workshopdir ]]; then
    cd $workshopdir
    for addon in $(find . -type f -name 'addon.vpk'); do

        ident=$(basename $(dirname "${addon}"))
        source="${workshopdir}/${addon}"
        target="${addonfolder}/${ident}.vpk"

        echo "linking ${source} > ${target}"
        ln -sf $source $target
    done
fi