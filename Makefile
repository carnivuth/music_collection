COLLECTION_DIR := /mnt/containers/navidrome/collection

$(COLLECTION_DIR)/%/missing_lyrics.txt: $(COLLECTION_DIR)/%
        find '$^' -type f -not -name '*.txt' -not -name '*.nsp' -not -name '*.m3u' -not -name 'cover.jpg' | \
                parallel "ffmpeg -i '{}' -f metadata | grep -q lyrics-XXX | echo '{}'" > '$@'

$(COLLECTION_DIR)/%/album_with_missing_lyrics.txt: $(COLLECTION_DIR)/%/missing_lyrics.txt
        cat $^ | \
                rev | \
                cut -d'/' -f 2- | \
                rev | \
                sort -u > $@
