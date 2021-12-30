export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk/
export DEVELOPER_DIR=/Applications/Xcode11.app/Contents/Developer
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:13.0

FINALPACKAGE = 1
DEBUG = 0

INSTALL_TARGET_PROCESSES = SpringBoard
TWEAK_NAME = DodontSuggest
$(TWEAK_NAME)_FILES = $(TWEAK_NAME).x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-error=deprecated-declarations
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LIBRARIES = colorpicker

SUBPROJECTS += Prefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk