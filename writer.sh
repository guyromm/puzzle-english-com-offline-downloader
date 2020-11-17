#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
for LURL in $(psql puzzle_english -t -c 'select url from lessons where contents_ts is not null and video_download_url is not null') ; do
    DDIR=$DIR/output$(dirname $(echo $LURL | cut -f2- -d'/'))
    echo 'LURL:'$LURL' => '$DDIR
    mkdir -p $DDIR
    psql puzzle_english -t -c "select contents from lessons where url='$LURL'" --output $DDIR/index.txt
    psql puzzle_english -t -c "select title from lessons where url='$LURL'" --output $DDIR/title.txt
    if [ ! -f $DDIR/video.txt ]; then
	cd $DDIR && youtube-dl "$(psql puzzle_english -t -c "select video_download_url from lessons where url='$LURL'")" ; cd -
	psql puzzle_english -t -c "select video_download_url from lessons where url='$LURL'" --output $DDIR/video.txt
	fi;
    done
