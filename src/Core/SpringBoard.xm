#import "SUF.h"

@interface SpringBoard : NSObject
@property(nonatomic, retain) SUFWindow *sufWindow;
@end

%hook SpringBoard
%property(nonatomic, retain) SUFWindow *sufWindow;
-(void)applicationDidFinishLaunching:(id)application {
	%orig;
	self.sufWindow = [SUFWindow sharedInstance];
}
%end

// ---------------------------------------------------------------------------------------------------------------------
// Initialization
// ---------------------------------------------------------------------------------------------------------------------

static void prefsUpdated() {
    [UFSettings refresh];
    tslog("prefsUpdated: %@", UFSettings.settings);
}

%ctor {
	if ([UFSettings isEnabled]) {
		CFNotificationCenterAddObserver(
			CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)prefsUpdated,
			CFSTR(kPackageNamePreferenceChanged), NULL, CFNotificationSuspensionBehaviorCoalesce
		);

		tslog("Switcher_UnicodeFaces plugin initialised.");
		%init;
	}
}
