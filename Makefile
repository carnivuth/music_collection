SHELL= /bin/bash
cdir ?= /mnt/data/navidrome/collection

.PHONY: $(cdir)

env: requirements.txt
	python3 -m venv env
	source env/bin/activate && pip install -r $^

~/.config/beets/config.yaml: config.yaml.j2
	rm -rf '$@'
	source env/bin/activate && jinja -D cdir $(cdir) -o '$@' < $^

to_import/%:
	mkdir -p '$@'
	( cd '$@' && cdda2wav -vall cddb=-1 speed=4 -B -D /dev/cdrom && rename  -e 's/audio_//' *.wav )

downloads:
	mkdir -p downloads
	docker build -f Containerfile --build-arg 'URL=$(URL)' --output=downloads .
