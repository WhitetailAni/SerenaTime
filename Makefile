TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SerenaTime

SerenaTime_FILES = Tweak.x
SerenaTime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += serenatimeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
