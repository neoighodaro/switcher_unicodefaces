#import "SUF.h"

@implementation SUFView
static CGFloat faceBtnH = 40;
static CGFloat faceBtnW = 180;

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:[self facesScrollView]];

		// Add constraints
        _facesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
		[NSLayoutConstraint activateConstraints:@[
			[_facesScrollView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
			[_facesScrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
			[_facesScrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
			[_facesScrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
		]];

        // Add faces
        [self addFacesToScrollview];
    }

    return self;
}

-(NSArray *)faces {
    if (_faces == nil) {
        _faces = @[
            @"¯\\_(ツ)_/¯", @"(⌐■_■)", @"๏̯͡๏﴿", @"q(●‿●)p", @"◎⃝ _◎⃝ ;", @"╭∩╮(-_-)╭∩╮", @"ಠ_ಠ", @"ಠ‿ಠ", @"ಠ╭╮ಠ",
            @"(ง’̀-’́)ง", @"ꏱ𐐃.𐐃ꎍ", @"(ಥ﹏ಥ)", @"ᕕ( ᐛ )ᕗ", @"◉_◉", @"( ◕ ◡ ◕ )", @"(╯°□°）╯︵ ┻━┻", @"┬─┬ノ( º _ ºノ)",
            @"(ு८ு_ .:)", @"ヽ(｀Д´)ﾉ", @"( ͡° ͜ʖ ͡°)", @"╿︡O͟-O︠╿", @"ʕ•ᴥ•ʔ", @"ʘ̃˻ʘ̃", @"༼ ༎ຶ ෴ ༎ຶ༽", @"(☞ﾟヮﾟ)☞ ", @"(ᵔᴥᵔ)",
            @"[̲̅$̲̅(̲̅5̲̅)̲̅$̲̅]", @"ヽ༼ຈل͜ຈ༽ﾉ", @"(´･ω･`)", @"(・_・、)(_・、 )(・、 )", @"ლ,ᔑ•ﺪ͟͠•ᔐ.ლ", @"⨀⦢⨀", @"º╲˚\\╭ᴖ_ᴖ╮/˚╱º",
            @"º(•♠•)º", @"✌ ⎦˚◡˚⎣ ✌"
        ];
    }

    return _faces;
}

-(UIScrollView *)facesScrollView {
    if (_facesScrollView == nil) {
        _facesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        _facesScrollView.userInteractionEnabled = YES;
    }
    return _facesScrollView;
}

-(void)addFacesToScrollview {
    NSInteger count = 0;
    NSLayoutYAxisAnchor *previousBottomAnchor = _facesScrollView.topAnchor;

    for (NSString *face in [self faces]) {
        count++;
        UIButton *btn = [self buttonWithFace:face];
        [_facesScrollView addSubview:btn];

        [NSLayoutConstraint activateConstraints:@[
            [btn.widthAnchor constraintEqualToConstant:faceBtnW],
            [btn.heightAnchor constraintEqualToConstant:faceBtnH],
            [btn.leadingAnchor constraintEqualToAnchor:_facesScrollView.leadingAnchor],
        ]];

        if (count == 1) {
            [btn.topAnchor constraintEqualToAnchor:_facesScrollView.topAnchor].active = YES;
            previousBottomAnchor = btn.bottomAnchor;
            continue;
        }

        [btn.topAnchor constraintEqualToAnchor:previousBottomAnchor].active = YES;
        previousBottomAnchor = btn.bottomAnchor;

        if (count == _faces.count) {
            [btn.bottomAnchor constraintEqualToAnchor:_facesScrollView.bottomAnchor].active = YES;
        }
    }
}

-(UIButton *)buttonWithFace:(NSString *)face {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = YES;
    btn.backgroundColor = [UIColor clearColor];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:face forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonWithFaceWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)buttonWithFaceWasPressed:(UIButton *)btn {
    NSString *selectedFace = [btn.currentTitle stringByAppendingString:@" "];
    [UIPasteboard generalPasteboard].string = selectedFace;

    // TODO: Use instance property instead: sWindow.statusNotificationName
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.tapsharp.switcher.Status"
                                                        object:self
                                                      userInfo:@{@"activate":@NO}];

    tslog("UFView:buttonWithFaceWasPressed: called: %@", selectedFace);
}
@end
