TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := amthanh

amthanh_FILES := Tweak.mm
amthanh_CFLAGS := -fobjc-arc -Wno-deprecated-declarations -O3
amthanh_FRAMEWORKS := UIKit AVFoundation WebKit QuartzCore CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
