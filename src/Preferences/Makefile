BUNDLE_NAME = UnicodeFaces
ARCHS = arm64 arm64e

UnicodeFaces_CFLAGS = -fobjc-arc -Isrc -include ../Shared/Macros.h -ferror-limit=0
UnicodeFaces_FILES = $(wildcard src/*.m)
UnicodeFaces_INSTALL_PATH = /Library/PreferenceBundles
UnicodeFaces_FRAMEWORKS = UIKit
UnicodeFaces_LIBRARIES += tapsharp
UnicodeFaces_PRIVATE_FRAMEWORKS = Preferences
UnicodeFaces_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Switcher_UnicodeFaces.plist$(ECHO_END)
