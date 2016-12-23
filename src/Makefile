ZIMG_RELEASE ?= release-2.3
VAPOURSYNTH_RELEASE ?= R35
MAKEFLAGS ?= "-j$(($(grep -c ^processor /proc/cpuinfo) + 1))"

all: vapoursynth plugins

install: vapoursynth_install plugins_install

clean:
	@rm -rf zimg-${ZIMG_RELEASE}
	@rm -rf vapoursynth-${VAPOURSYNTH_RELEASE}
	@rm -rf vapoursynth-plugins
	
distclean: clean
	@rm -rf /usr/local/*

.ONESHELL:
## ZImg: https://github.com/sekrit-twc/zimg/blob/master/README.md
zimg-${ZIMG_RELEASE}:
	curl -sL https://github.com/sekrit-twc/zimg/archive/${ZIMG_RELEASE}.tar.gz | tar -xz   

zimg-${ZIMG_RELEASE}/Makefile: zimg-${ZIMG_RELEASE}
	cd zimg-${ZIMG_RELEASE}  
	./autogen.sh   
	./configure  

zimg: zimg-${ZIMG_RELEASE}/Makefile
	$(MAKE) -C zimg-${ZIMG_RELEASE} 

zimg_install: zimg
	$(MAKE) -C zimg-${ZIMG_RELEASE} install

## VapourSynth: https://github.com/vapoursynth/vapoursynth/README.md
vapoursynth-${VAPOURSYNTH_RELEASE}:
	curl -sL https://github.com/vapoursynth/vapoursynth/archive/${VAPOURSYNTH_RELEASE}.tar.gz | tar -xz

vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile: vapoursynth-${VAPOURSYNTH_RELEASE} zimg_install
	cd vapoursynth-${VAPOURSYNTH_RELEASE}
	./autogen.sh
	./configure

vapoursynth: vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile
	${MAKE} -C vapoursynth-${VAPOURSYNTH_RELEASE} 

vapoursynth_install: vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile
	${MAKE} -C vapoursynth-${VAPOURSYNTH_RELEASE} install

## VapourSynth Plugins: https://github.com/darealshinji/vapoursynth-plugins
vapoursynth-plugins:
	git clone https://github.com/darealshinji/vapoursynth-plugins.git
	git apply --directory=vapoursynth-plugins vapoursynth-plugins.patch

vapoursynth-plugins/Makefile: vapoursynth-plugins
	cd vapoursynth-plugins
	./autogen.sh
	./configure

plugins: vapoursynth-plugins/Makefile
	${MAKE} -C vapoursynth-plugins 

plugins_install: vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile
	${MAKE} -C vapoursynth-${VAPOURSYNTH_RELEASE} install


.PHONY: all install clean distclean
