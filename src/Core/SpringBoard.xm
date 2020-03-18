#import "SUF.h"

@interface SpringBoard : NSObject
@property(nonatomic, retain) SUFWindow *sufWindow;
@end

%hook SpringBoard
%property(nonatomic, retain) SUFWindow *sufWindow;
-(void)applicationDidFinishLaunching:(id)application {
	%orig;

	if ([[SUFSettings sharedInstance] isEnabled]) {
		tslog("Switcher_UnicodeFaces plugin initialised.");
		self.sufWindow = [SUFWindow sharedInstance];
	}
}
%end
