/mnt/containers/navidrome/collection/%/missing_lyrics.txt: /mnt/containers/navidrome/collection/%
        find '$^' -type f -not -name '*.txt' -not -name '*.nsp' -not -name '*.m3u' -not -name 'cover.jpg' | \
                parallel "ffmpeg -i '{}' -f metadata | grep -q lyrics-XXX | echo '{}'" > '$@'

album_with_missing_lyrics.txt: missing_lyrics.txt
        cat $^ | \
                rev | \
                cut -d'/' -f 2- | \
                rev | \
                sort -u > $@
