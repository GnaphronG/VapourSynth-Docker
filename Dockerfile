FROM alpine:3.4

WORKDIR /data
ENTRYPOINT ["vspipe"]

COPY ./build/bin    /usr/local/bin
COPY ./build/lib    /usr/local/lib

RUN apk add --no-cache --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
        lcms2 \
        ffmpeg \
        libass \
        cython \
        python3 \
        imagemagick \
        tesseract-ocr
