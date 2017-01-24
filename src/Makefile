VAPOURSYNTH_RELEASE ?= R36
ifeq ($(VAPOURSYNTH_RELEASE), R35)
ZIMG_RELEASE ?= release-2.3
else 
ZIMG_RELEASE ?= release-2.4
endif
PREFIX ?= /usr/local
JOBS := $(shell echo $$(( $$(grep -c ^processor /proc/cpuinfo) + 1 )))

all: vapoursynth plugins

install: vapoursynth_install plugins_install

clean:
	@rm -rf zimg-${ZIMG_RELEASE}
	@rm -rf vapoursynth-${VAPOURSYNTH_RELEASE}
	@rm -rf vapoursynth-plugins
	
distclean: clean
	@rm -rf /usr/local/*

## ZImg: https://github.com/sekrit-twc/zimg/blob/master/README.md
zimg-${ZIMG_RELEASE}:
	@curl -sL https://github.com/sekrit-twc/zimg/archive/${ZIMG_RELEASE}.tar.gz | tar -xz   

zimg-${ZIMG_RELEASE}/Makefile: zimg-${ZIMG_RELEASE}
	@cd zimg-${ZIMG_RELEASE} && \
		./autogen.sh  && \
		./configure --prefix=${PREFIX} 
	@touch zimg-${ZIMG_RELEASE}/Makefile

zimg: zimg-${ZIMG_RELEASE}/Makefile
	$(MAKE) -j ${JOBS} -C zimg-${ZIMG_RELEASE} 
	@touch zimg-${ZIMG_RELEASE}/Makefile

${PREFIX}/lib/pkgconfig/zimg.pc: zimg
	$(MAKE) -C zimg-${ZIMG_RELEASE} install

## VapourSynth: https://github.com/vapoursynth/vapoursynth/README.md
vapoursynth-${VAPOURSYNTH_RELEASE}:
	@curl -sL https://github.com/vapoursynth/vapoursynth/archive/${VAPOURSYNTH_RELEASE}.tar.gz | tar -xz

vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile: vapoursynth-${VAPOURSYNTH_RELEASE} ${PREFIX}/lib/pkgconfig/zimg.pc
	@cd vapoursynth-${VAPOURSYNTH_RELEASE} && \
		./autogen.sh && \
		./configure
	@touch vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile 

vapoursynth: vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile
	${MAKE} -j ${JOBS} -C vapoursynth-${VAPOURSYNTH_RELEASE} 
	@touch vapoursynth-${VAPOURSYNTH_RELEASE}/Makefile 

${PREFIX}/lib/pkgconfig/vapoursynth.pc: vapoursynth
	${MAKE} -C vapoursynth-${VAPOURSYNTH_RELEASE} install

vapoursynth_install: ${PREFIX}/lib/pkgconfig/vapoursynth.pc

## VapourSynth Plugins: https://github.com/darealshinji/vapoursynth-plugins
vapoursynth-plugins:
	git clone https://github.com/darealshinji/vapoursynth-plugins.git
#	git apply --directory=vapoursynth-plugins vapoursynth-plugins.patch

vapoursynth-plugins/Makefile: vapoursynth-plugins ${PREFIX}/lib/pkgconfig/vapoursynth.pc
	@cd vapoursynth-plugins && \
		./autogen.sh && \
		./configure 
	@touch vapoursynth-plugins/Makefile 

plugins: vapoursynth-plugins/Makefile
	${MAKE} -j ${JOBS} -C vapoursynth-plugins 
	@touch vapoursynth-plugins/Makefile 

plugins_install: plugins
	${MAKE} -C vapoursynth-plugins install


.PHONY: all install clean distclean vapoursynth_install plugins_install
