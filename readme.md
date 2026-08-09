# Personal Music Collection management utilities

This repo serves as a mini tool to manage my personal music collection, it uses [`beets`](https://beets.readthedocs.io/en/v2.5.0/index.html) to manage metadata and file naming, it also stores some  informations regarding my personal album collection

- configure beet

```bash
make env
make ~/.config/bneet/config.yaml cdir="path to your collection directory"
```

- mount your collection using sshfs

```bash
make path="path to your collection directory" cdir="path to your collection directory"
```

- get albums with wrong file name scheme:

```bash
make wrong_albums.txt
```
