TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = amthanh

amthanh_FILES = Tweak.mm
amthanh_FRAMEWORKS = UIKit Foundation AVFoundation CoreGraphics QuartzCore
amthanh_CFLAGS = -fobjc-arc -O3

include $(THEOS_MAKE_PATH)/tweak.mk
