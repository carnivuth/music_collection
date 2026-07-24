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


$(collection_dir)/%.lrc:  $(collection_dir)/$(firstword $(wildcard %.opus %.m4a %.wav %.flac %.mp3))
	curl -X GET 'https://lrclib.net/api/search?track_name=$(shell echo '$*' | sed -n 's/.*[0-9][0-9]-[0-9][0-9]\. \(.*\)\.[a-z0-9][a-z0-9]*/\1/p' | tr ' ' '+')&artist_name=$(shell echo '$*' | awk -F'/' '{print $$1}' | tr ' ' '+')&album_name=$(shell echo '$*' | awk -F'/' '{print $$2}' | tr ' ' '+' )' | \
		jq '[.[] | select(.syncedLyrics != null)][0].lyricsfile' -r | \
		parallel echo -e > '$@'
