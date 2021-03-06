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

-(BOOL)onKeyboard {
    return [self boolForKey:@"on_keyboard" fallback:YES];
}

-(NSArray *)faces {
    return [self arrayForKey:@"faces" fallback:kDefaultFaces];
}
@end
