TARGET := iphone:clang:16.5:15.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SerenaTimePrefs

SerenaTimePrefs_FILES = STRootListController.m
SerenaTimePrefs_FRAMEWORKS = UIKit
SerenaTimePrefs_PRIVATE_FRAMEWORKS = Preferences
SerenaTimePrefs_INSTALL_PATH = /Library/PreferenceBundles
SerenaTimePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
