#import <TapSharp/TSPrefsManager.h>
#import "../../Shared/Macros.h"

@interface SUFSettings : TSPrefsManager
@property(nonatomic, readonly, getter=onKeyboard) BOOL onKeyboard;
+(instancetype)sharedInstance;
@end
