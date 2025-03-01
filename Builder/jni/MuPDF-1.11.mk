# Android makefile to be used with ndk-build.
#
# Run ndk-build with the following arguments:
#	APP_BUILD_SCRIPT=platform/java/Android.mk (this file)
#	APP_PROJECT_DIR=build/android (where you want the output)
#	APP_PLATFORM=android-16
#	APP_OPTIM=release (or debug)
#	APP_ABI=all (or armeabi, armeabi-v7a, arm64-v8a, x86, x86_64, mips, mips64)
#
# The top-level Makefile will invoke ndk-build with appropriate arguments
# if you run 'make android'.
#
# LOCAL_C_INCLUDES paths are relative to the NDK root directory.
# LOCAL_SRC_FILES paths are relative to LOCAL_PATH.
#
# We make sure to use absolute paths everywhere, so this makefile works
# regardless of where it is called from.

LOCAL_PATH := $(call my-dir)
MUPDF_PATH := $(realpath $(LOCAL_PATH)/../../..)

# --- Include pre-built ghostscript library if building with gproof support ---

ifdef FZ_ENABLE_GPRF
include $(CLEAR_VARS)
LOCAL_MODULE := gsso
LOCAL_SRC_FILES := libgs.so
include $(PREBUILT_SHARED_LIBRARY)
endif

# --- Build a local static library for core mupdf ---

include $(CLEAR_VARS)

LOCAL_CFLAGS    := $(APP_CFLAGS)
LOCAL_CPPFLAGS  := $(APP_CPPFLAGS)
LOCAL_ARM_MODE  := $(APP_ARM_MODE)

LOCAL_MODULE := mupdf_core

LOCAL_STATIC_LIBRARIES := webpmux webpdemux webp


ifdef FZ_ENABLE_GPRF
LOCAL_CFLAGS += -DFZ_ENABLE_GPRF
endif


LOCAL_C_INCLUDES := \
	$(MUPDF_PATH)/include \
	$(MUPDF_PATH)/generated \
	$(MUPDF_PATH)/scripts/freetype \
	$(MUPDF_PATH)/scripts/libjpeg \
	$(MUPDF_PATH)/thirdparty/freetype/include \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src \
	$(MUPDF_PATH)/thirdparty/jbig2dec \
	$(MUPDF_PATH)/thirdparty/libjpeg \
	$(MUPDF_PATH)/thirdparty/mujs \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2 \
	$(MUPDF_PATH)/thirdparty/zlib \


LOCAL_CFLAGS := \
	-ffunction-sections -fdata-sections \
	-DNOTO_SMALL \
	-DAA_BITS=8 \

LOCAL_SRC_FILES += \
	$(wildcard $(MUPDF_PATH)/source/fitz/*.c) \
	$(wildcard $(MUPDF_PATH)/source/pdf/*.c) \
	$(wildcard $(MUPDF_PATH)/source/xps/*.c) \
	$(wildcard $(MUPDF_PATH)/source/svg/*.c) \
	$(wildcard $(MUPDF_PATH)/source/cbz/*.c) \
	$(wildcard $(MUPDF_PATH)/source/gprf/*.c) \
	$(wildcard $(MUPDF_PATH)/source/html/*.c) \
	$(wildcard $(MUPDF_PATH)/generated/*.c) \


include $(BUILD_STATIC_LIBRARY)

# --- Build a local static library for thirdparty libraries ---

include $(CLEAR_VARS)
LOCAL_CFLAGS    := $(APP_CFLAGS)
LOCAL_CPPFLAGS  := $(APP_CPPFLAGS)
LOCAL_ARM_MODE  := $(APP_ARM_MODE)

LOCAL_MODULE := mupdf_thirdparty

LOCAL_CPP_EXTENSION := .cc

LOCAL_C_INCLUDES := \
	$(MUPDF_PATH)/include \
	$(MUPDF_PATH)/scripts/freetype \
	$(MUPDF_PATH)/scripts/libjpeg \
	$(MUPDF_PATH)/thirdparty/freetype/include \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src \
	$(MUPDF_PATH)/thirdparty/jbig2dec \
	$(MUPDF_PATH)/thirdparty/libjpeg \
	$(MUPDF_PATH)/thirdparty/mujs \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2 \
	$(MUPDF_PATH)/thirdparty/zlib \

LOCAL_CFLAGS := \
	-ffunction-sections -fdata-sections \
	-DFT2_BUILD_LIBRARY -DDARWIN_NO_CARBON \
	'-DFT_CONFIG_MODULES_H="slimftmodules.h"' \
	'-DFT_CONFIG_OPTIONS_H="slimftoptions.h"' \
	-DHAVE_STDINT_H \
	-DOPJ_STATIC -DOPJ_HAVE_INTTYPES_H -DOPJ_HAVE_STDINT_H -DUSE_JPIP \

LOCAL_CPPFLAGS := \
	-ffunction-sections -fdata-sections \
	-fno-rtti -fno-exceptions -fvisibility-inlines-hidden --std=c++0x \
	-DHAVE_OT -DHAVE_UCDN -DHB_NO_MT \
	-Dhb_malloc_impl=hb_malloc \
	-Dhb_calloc_impl=hb_calloc \
	-Dhb_realloc_impl=hb_realloc \
	-Dhb_free_impl=hb_free \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftbase.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftbbox.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftbitmap.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftfntfmt.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftgasp.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftglyph.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftinit.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftstroke.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftsynth.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/ftsystem.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/base/fttype1.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/cff/cff.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/cid/type1cid.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/psaux/psaux.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/pshinter/pshinter.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/psnames/psnames.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/raster/raster.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/sfnt/sfnt.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/smooth/smooth.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/truetype/truetype.c \
	$(MUPDF_PATH)/thirdparty/freetype/src/type1/type1.c \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-blob.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-buffer-serialize.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-buffer.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-common.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-face.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-fallback-shape.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-font.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ft.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-font.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-layout.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-map.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-arabic.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-default.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-hangul.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-hebrew.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-indic-table.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-indic.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-myanmar.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-thai.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-tibetan.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-use-table.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-complex-use.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-fallback.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape-normalize.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-shape.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ot-tag.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-set.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-shape-plan.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-shape.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-shaper.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-ucdn.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-unicode.cc \
	$(MUPDF_PATH)/thirdparty/harfbuzz/src/hb-warning.cc \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_arith.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_arith_iaid.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_arith_int.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_generic.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_halftone.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_huffman.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_image.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_metadata.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_mmr.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_page.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_refinement.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_segment.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_symbol_dict.c \
	$(MUPDF_PATH)/thirdparty/jbig2dec/jbig2_text.c \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/libjpeg/jaricom.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jcomapi.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdapimin.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdapistd.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdarith.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdatadst.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdatasrc.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdcoefct.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdcolor.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jddctmgr.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdhuff.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdinput.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdmainct.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdmarker.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdmaster.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdmerge.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdpostct.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdsample.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jdtrans.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jerror.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jfdctflt.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jfdctfst.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jfdctint.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jidctflt.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jidctfst.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jidctint.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jmemmgr.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jquant1.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jquant2.c \
	$(MUPDF_PATH)/thirdparty/libjpeg/jutils.c \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/mujs/one.c \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/bio.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/cidx_manager.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/cio.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/dwt.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/event.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/function_list.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/image.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/invert.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/j2k.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/jp2.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/mct.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/mqc.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/openjpeg.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/phix_manager.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/pi.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/ppix_manager.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/raw.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/t1.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/t2.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/tcd.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/tgt.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/thix_manager.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/thread.c \
	$(MUPDF_PATH)/thirdparty/openjpeg/src/lib/openjp2/tpix_manager.c \

LOCAL_SRC_FILES += \
	$(MUPDF_PATH)/thirdparty/zlib/adler32.c \
	$(MUPDF_PATH)/thirdparty/zlib/compress.c \
	$(MUPDF_PATH)/thirdparty/zlib/crc32.c \
	$(MUPDF_PATH)/thirdparty/zlib/deflate.c \
	$(MUPDF_PATH)/thirdparty/zlib/inffast.c \
	$(MUPDF_PATH)/thirdparty/zlib/inflate.c \
	$(MUPDF_PATH)/thirdparty/zlib/inftrees.c \
	$(MUPDF_PATH)/thirdparty/zlib/trees.c \
	$(MUPDF_PATH)/thirdparty/zlib/uncompr.c \
	$(MUPDF_PATH)/thirdparty/zlib/zutil.c \

include $(BUILD_STATIC_LIBRARY)
