TWEAK_NAME = Switcher_UnicodeFaces

ARCHS = arm64 arm64e

Switcher_UnicodeFaces_CFLAGS = -fobjc-arc -Isrc -ferror-limit=0
Switcher_UnicodeFaces_FILES = src/SpringBoard.xm src/SUFWindow.m src/SUFView.m
Switcher_UnicodeFaces_LIBRARIES += tapsharp

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
