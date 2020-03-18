#import "SUF.h"

// ---------------------------------------------------------------------------------------------------------------------
// Animation Helper
// ---------------------------------------------------------------------------------------------------------------------

static NSMutableArray *animationBlocks;
animationBlock (^getNextAnimation)() = ^{
    animationBlock block = (animationBlock)[animationBlocks firstObject];
    if (block){
        [animationBlocks removeObjectAtIndex:0];
        return block;
    } else {
        return ^(BOOL finished){};
    }
};


// ---------------------------------------------------------------------------------------------------------------------
// SUF!
// ---------------------------------------------------------------------------------------------------------------------

@implementation SUFViewController
@end


@implementation SUFWindow : UIWindow
static CGFloat sufWindowW = 200;
static BOOL keyboardIsShowing = NO;
static CGFloat spacingFromSwitcherWindow = 10;

+(instancetype)sharedInstance {
	static dispatch_once_t once = 0;
    __strong static id sharedInstance = nil;
	dispatch_once(&once, ^{ sharedInstance = [[self alloc] initWithPresetFrame]; });
	return sharedInstance;
}

-(instancetype)initWithPresetFrame {
    animationBlocks = [NSMutableArray new];
    CKSwitcherWindow *sWindow = [NSClassFromString(@"CKSwitcherWindow") sharedInstance];

    // TODO: Get from switcher property maybe
    CGFloat sWindowShrunkH = 100;
    CGFloat sWindowCornerRadius = 16;

    CGFloat sWindowH = sWindow.bounds.size.width;
    CGFloat x = [self calculateXPosition];
    CGFloat y = sWindow.frame.origin.y - ((sWindowH / 2) - (sWindowShrunkH / 2));

    if (self = [super initWithFrame:CGRectMake(x, y, sufWindowW, sWindowH)]) {
        _switcherWindow = sWindow;

        self.alpha = 0;
        self.opaque = NO;
        self.hidden = NO;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        self.windowLevel = UIWindowLevelAlert - 1;
        self.backgroundColor = [UIColor clearColor];
        self.rootViewController = [SUFViewController new];
        self.layer.cornerRadius = sWindowCornerRadius;
        if (@available(iOS 13.0, *)) {
            self.layer.cornerCurve = kCACornerCurveContinuous;
        } else {
            self.layer.continuousCorners = YES;
        }

        // Add subviews!
        [self addSubview:[self blurryBackgroundView]];
        [self addSubview:[self facesView]];

        // Add constraints to subviews!
        _facesView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [_facesView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10],
            [_facesView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10],
            [_facesView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
            [_facesView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
        ]];

        [self registerSwitcherListener];
        [self registerKeyboardListeners];
    }

	return self;
}

-(SUFView *)facesView {
    if (_facesView == nil) {
        _facesView = [[SUFView alloc] initWithFrame:CGRectZero];
        _facesView.userInteractionEnabled = YES;
        _facesView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _facesView;
}

-(UIVisualEffectView *)blurryBackgroundView {
    if (_blurryBackgroundView == nil) {
        UIBlurEffectStyle style = [[NSClassFromString(@"CKSwitcherSettings") shared] displayMode] == CKSwitcherDisplayModeLight
            ? UIBlurEffectStyleLight
            : UIBlurEffectStyleDark;

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
        _blurryBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurryBackgroundView.frame = self.bounds;
        _blurryBackgroundView.layer.masksToBounds = YES;
        _blurryBackgroundView.userInteractionEnabled = YES;
        _blurryBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

	return _blurryBackgroundView;
}

-(CGFloat)calculateXPosition {
    CGFloat framePosition = 0;
	BOOL secondColumnActive = [[NSClassFromString(@"CKSwitcherSettings") shared] isSecondColumnActive];
	CGFloat switcherWindowW = (45 * (secondColumnActive ? 2 : 1)) + (25 + (secondColumnActive ? 15 : 0));
	CKSwitcherWindowPosition switcherWindowPosition = CKSwitcherWindowPositionRight;

	if (switcherWindowPosition == CKSwitcherWindowPositionLeft) {
		framePosition = spacingFromSwitcherWindow + switcherWindowW;
	} else {
    	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	    framePosition = (screenWidth - sufWindowW - spacingFromSwitcherWindow - switcherWindowW);
    }

    tslog("SUFWindow:calculateXPosition: called. position: %f", framePosition);
    return framePosition;
}

-(void)switcherStatusWasChanged:(NSNotification *)notification {
    tslog("SUFWindow:switcherStatusWasChanged: was called: %@", notification);
	BOOL shouldActivate = [[notification.userInfo objectForKey:@"activate"] boolValue];
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((shouldActivate ? 0.3 : 0) * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
	    [self setActive:shouldActivate];
	});
}

-(void)setActive:(BOOL)shouldActivate {
    tslog("SUFWindow:setActive: was called: %@", @(shouldActivate));

    if (
        (shouldActivate && self.alpha == 1) ||
        (shouldActivate == NO && self.alpha == 0) ||
        (shouldActivate && keyboardIsShowing == NO && [[SUFSettings sharedInstance] onKeyboard] == YES)
    ) {
        tslog("SUFWindow:setActive: call ignored");
        return;
    }

    if (shouldActivate == YES) {
        [self setHidden:NO];
    }

    [animationBlocks addObject:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = (shouldActivate ? 1 : 0);
        } completion: getNextAnimation()];
    }];

    if (shouldActivate == NO) {
        [animationBlocks addObject:^(BOOL finished) {
            [UIView animateWithDuration:0.01 animations:^{
                [self setHidden:YES];
            } completion: getNextAnimation()];
        }];
    }

    getNextAnimation()(YES);
}

-(void)registerSwitcherListener {
    // TODO: Use instance property instead: sWindow.statusNotificationName
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(switcherStatusWasChanged:)
                                                name:@"com.tapsharp.switcher.Status"
                                            object:_switcherWindow];
}

-(void)registerKeyboardListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardDidShow)
                                                name:UIKeyboardDidShowNotification
                                            object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardDidHide)
                                                name:UIKeyboardDidHideNotification
                                            object:nil];
}

-(void)keyboardDidHide {
    keyboardIsShowing = NO;
}

-(void)keyboardDidShow {
    keyboardIsShowing = YES;
}
@end
