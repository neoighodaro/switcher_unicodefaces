#import "SUFSettings.h"

@implementation SUFSettings
+(instancetype)sharedInstance {
	static dispatch_once_t once = 0;
    __strong static id sharedInstance = nil;
	dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithAppID:CFSTR(kPackageBundleID) defaults:nil];
    });
	return sharedInstance;
}
@end
