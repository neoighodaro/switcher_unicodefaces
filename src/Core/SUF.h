#import <TapSharp/TSCommon.h>

@interface CALayer (Undocumented)
@property (assign) BOOL continuousCorners;
@end

// ---------------------------------------------------------------------------------------------------------------------
// Switcher!
// ---------------------------------------------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, CKSwitcherWindowPosition) {
    CKSwitcherWindowPositionLeft,
    CKSwitcherWindowPositionRight
};

typedef NS_ENUM(NSInteger, CKSwitcherDisplayMode) {
    CKSwitcherDisplayModeDark,
    CKSwitcherDisplayModeLight,
    CKSwitcherDisplayModeSystem
};

@interface CKSwitcherSettings : NSObject
@property(nonatomic, readonly, getter=displayMode) CKSwitcherDisplayMode displayMode;
@property(nonatomic, readonly, getter=isSecondColumnActive) BOOL secondColumnActive;
+(instancetype)shared;
@end

@interface CKSwitcherWindow : UIWindow
@property(nonatomic) NSString *statusNotificationName;
+(instancetype)sharedInstance;
@end

@interface CKHapticEngineHelper : NSObject
@property (nonatomic, retain) UIImpactFeedbackGenerator *impact;
+(instancetype)sharedInstance;
-(void)prepare;
-(void)fire;
@end


// ---------------------------------------------------------------------------------------------------------------------
// SUF!
// ---------------------------------------------------------------------------------------------------------------------

typedef void(^animationBlock)(BOOL);

@interface SUFView : UIView
@property(nonatomic, retain) NSArray *faces;
@property(nonatomic, retain) UIScrollView *facesScrollView;
-(void)addFacesToScrollview;
-(UIButton *)buttonWithFace:(NSString *)face;
-(void)buttonWithFaceWasPressed:(UIButton *)btn;
@end

@interface SUFViewController : UIViewController
@end

@interface SUFWindow : UIWindow
@property(nonatomic, retain) SUFView *facesView;
@property(nonatomic, retain) CKSwitcherWindow *switcherWindow;
@property(nonatomic, retain) UIVisualEffectView *blurryBackgroundView;
+ (instancetype)sharedInstance;
-(CGFloat)calculateXPosition;
-(void)setActive:(BOOL)active;
-(void)switcherStatusWasChanged:(NSNotification *)notification;
-(void)registerSwitcherListener;
-(void)registerKeyboardListeners;
-(void)keyboardDidHide;
-(void)keyboardDidShow;
@end
