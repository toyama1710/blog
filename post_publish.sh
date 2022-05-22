#!/bin/bash

PUBLISH=content/posts/`date '+%Y/%m/%d'`


for F in $*
do
    if [ -f $F ]; then
        if [ ! -d $PUBLISH ]; then
            mkdir -p $PUBLISH
        fi
        T=`date '+%Y-%m-%dT%H:%M:%S%:z'`
        sed -i -e '0,/^draft:.*/s/^draft:.*/draft: false/' $F
        sed -i -e '0,/^date:.*/s/^date:.*/date: '$T'/' $F
        
        mv $F $PUBLISH
    else
        echo ''$F' not found'
    fi
done
