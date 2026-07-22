collection_dir ?= ~/collection

collection_dir := $(patsubst %/,%,$(collection_dir))

$(collection_dir)/%/missing_lyrics.txt: $(collection_dir)/%
	find '$^' -type f -not -name '*.txt' -not -name '*.nsp' -not -name '*.m3u' -not -name 'cover.jpg' | \
  	parallel ffmpeg -i '{}' -f metadata -loglevel 0 \| grep -q lyrics-XXX \| echo '{}'  > '$@'

$(collection_dir)/%/album_with_missing_lyrics.txt: $(collection_dir)/%/missing_lyrics.txt
	cat $^ | \
  	rev | \
    cut -d'/' -f 2- | \
    rev | \
    sort -u > '$@'
