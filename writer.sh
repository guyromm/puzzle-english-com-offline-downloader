#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
for LURL in $(psql puzzle_english -t -c 'select url from lessons where contents_ts is not null and video_download_url is not null') ; do
    DDIR=$DIR/output$(dirname $(echo $LURL | cut -f2- -d'/'))
    #echo 'LURL:'$LURL' => '$DDIR
    echo $LURL
    mkdir -p $DDIR
    psql puzzle_english -qAtX -c "select contents from lessons where url='$LURL'" --output $DDIR/index.txt
    psql puzzle_english -qAtX -c "select title from lessons where url='$LURL'" --output $DDIR/title.txt
    if [ ! -f $DDIR/video.txt ]; then
	cd $DDIR && youtube-dl "$(psql puzzle_english -t -c "select video_download_url from lessons where url='$LURL'")" ; cd -
	psql puzzle_english -qAtX -c "select video_download_url from lessons where url='$LURL'" --output $DDIR/video.txt
    fi;
    VFN=$(basename $(ls $DDIR/*mp4))
    echo "<html><head><title>$(cat $DDIR/title.txt)</title></head><body><h1>$(cat $DDIR/title.txt)</h1><a href='$VFN'>video</a><pre>$(cat $DDIR/index.txt)</pre></body></html>" > $DDIR/index.html
    done
