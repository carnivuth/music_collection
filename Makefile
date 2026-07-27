SHELL= /bin/bash
cdir ?= $(shell pwd)/collection

.PHONY: $(cdir)

env: requirements.txt
	python3 -m venv env
	source env/bin/activate && pip install -r $^

~/.config/beets/config.yaml: config.yaml.j2
	rm -rf '$@'
	source env/bin/activate && jinja -D cdir $(cdir) -o '$@' < $^

$(cdir):
	mkdir -p '$@'
	sshfs avalug.local.carnivuth.org:/mnt/containers/navidrome/collection '$@'

to_import/%:
	mkdir -p '$@'
	( cd '$@' && cdda2wav -vall cddb=-1 speed=4 -B)

wrong_filename.txt:
	find  '$(cdir)' \
    -not -name '[0-9][0-9]-[0-9][0-9]. *' \
    -not -name 'cover.png' \
    -not -name 'cover.[0-9]*.png' \
    -not -name 'cover.jpg' \
    -not -name 'cover.[0-9]*.jpg' \
    -not -name '*.nsp' \
    -not -name  '*.m3u' \
    -type f > '$@'

#define album_missing_file
#	cat $^ | \
#  	rev | \
#    cut -d'/' -f 2- | \
#    rev | \
#    sort -u > '$@'
#endef
#collection/%/missing_genre.txt: collection/%
#	find '$^' -type f -not -name '*.txt' -not -name '*.nsp' -not -name '*.m3u' -not -name 'cover.jpg' | \
#  	parallel ffmpeg -i '{}' -f metadata -loglevel 0 \| grep -q Genre \| echo '{}'  > '$@'
#
#collection/%/album_with_missing_genre.txt: collection/%/missing_genre.txt
#	$(album_missing_file)
#
#collection/%/missing_lyrics.txt: collection/%
#	find '$^' -type f -not -name '*.txt' -not -name '*.nsp' -not -name '*.m3u' -not -name 'cover.jpg' | \
#  	parallel ffmpeg -i '{}' -f metadata -loglevel 0 \| grep -q lyrics-XXX \| echo '{}'  > '$@'
#
#collection/%/album_with_missing_lyrics.txt: collection/%/missing_lyrics.txt
#	$(album_missing_file)
#
#
#collection/%.lrc:  collection/$(firstword $(wildcard %.opus %.m4a %.wav %.flac %.mp3))
#	echo '$*'
#	curl -s -X GET 'https://lrclib.net/api/search?track_name=$(shell echo '$*' | sed -n 's/.*[0-9][0-9]*\(-[0-9][0-9]\)*\. \(.*\)\.[a-z0-9][a-z0-9]*/\2/p' | tr ' ' '+')&artist_name=$(shell echo '$*' | awk -F'/' '{print $$1}' | tr ' ' '+')&album_name=$(shell echo '$*' | awk -F'/' '{print $$2}' | tr ' ' '+' )' > '/tmp/$@'
#		jq  '[.[] | select(.syncedLyrics != null)][0].lyricsfile' '/tmp/$@' -r | \
#		parallel echo -e > '$@'
#
