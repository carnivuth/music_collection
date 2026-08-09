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
	test -f '$@/library.db' || sshfs torterra.carnivuth.org:/mnt/data/navidrome/collection '$@'

to_import/%:
	mkdir -p '$@'
	( cd '$@' && cdda2wav -vall cddb=-1 speed=4 -B -D /dev/cdrom )

wrong_albums.txt: wrong_filename.txt
	cat $^ | \
  	rev | \
    cut -d'/' -f 2- | \
    rev | \
    sort -u > '$@'

wrong_filename.txt: $(cdir)
	( cd '$(cdir)' && find   \
    -not -name '[0-9][0-9]-[0-9][0-9]. *' \
    -not -name 'cover.png' \
    -not -name 'cover.[0-9]*.png' \
    -not -name 'cover.jpg' \
    -not -name 'cover.[0-9]*.jpg' \
    -not -name '*.nsp' \
    -not -name  '*.m3u' \
    -type f  ) > '$@'

