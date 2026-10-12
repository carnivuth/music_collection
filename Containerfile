FROM alpine:3.24 AS deps
RUN apk add yt-dlp
FROM deps AS download
ARG URL
WORKDIR /output
RUN yt-dlp -x --audio-format mp3 --audio-quality 0 \
  -o "%(playlist_title)s/%(playlist_index)03d - %(title)s.%(ext)s" \
  "${URL}"

FROM scratch
COPY --from=download /output /
