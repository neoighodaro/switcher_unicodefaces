#import <TapSharp/TSPrefsManager.h>
#import "../../Shared/Macros.h"

@interface SUFSettings : TSPrefsManager
@property(nonatomic, readonly, getter=onKeyboard) BOOL onKeyboard;
@property(nonatomic, readonly, getter=faces) NSArray *faces;
+(instancetype)sharedInstance;
@end
