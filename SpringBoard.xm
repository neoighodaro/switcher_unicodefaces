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
