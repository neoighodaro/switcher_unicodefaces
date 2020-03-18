TWEAK_NAME = Switcher_UnicodeFaces

ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

Switcher_UnicodeFaces_CFLAGS = -fobjc-arc -Isrc -include src/Preferences/src/SUFSettings.h -ferror-limit=0
Switcher_UnicodeFaces_FILES = $(wildcard src/Core/*.m) src/Core/SpringBoard.xm src/Preferences/src/SUFSettings.m
Switcher_UnicodeFaces_LIBRARIES += tapsharp

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/bundle.mk

SUBPROJECTS += src/Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk

_install::
	export THEOS_DEVICE_IP=192.168.0.194; make install
	export THEOS_DEVICE_IP=192.168.0.75; make install
	# export THEOS_DEVICE_IP=192.168.0.19; make install

after-install::
	install.exec "killall -9 SpringBoard"

after-uninstall::
	install.exec "killall -9 SpringBoard"
