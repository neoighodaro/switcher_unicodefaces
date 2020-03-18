#include <spawn.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <CepheiPrefs/HBRootListController.h>

@interface SUFRootListController : HBRootListController
+(NSString*)hb_specifierPlist;
-(void)respringDevice;
@end


@implementation SUFRootListController
+(NSString*)hb_specifierPlist {
	return @"UnicodeFaces";
}

-(instancetype)init {
    if (self = [super init]) {
        HBAppearanceSettings *settings = [[HBAppearanceSettings alloc] init];
        settings.tintColor = UIColorFromRGB(27, 73, 101);
        self.hb_appearanceSettings = settings;
    }

    return self;
}

-(void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.titleView = [UIView new];
    self.navigationItem.titleView.alpha = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    if (@available(iOS 11, *)) {
        [self realNavigationController].navigationBar.prefersLargeTitles = NO;
    }

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
															                  style:UIBarButtonItemStyleDone
															                 target:self
															                 action:@selector(respringDevice)];

    [super viewWillAppear:animated];
}

-(void)respringDevice {
    NSString *message = @"To show saved changed, your device will have to respring. Do you want to continue?";
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Respring Device?"
												                   message:message
												            preferredStyle:UIAlertControllerStyleAlert];

    // Respring!
	[alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		pid_t pid;
		int status;
		const char* args[] = {"killall", "-9", "SpringBoard", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char*   const*)args, NULL);
		waitpid(pid, &status, WEXITED);
	}]];

    // Cancel!
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	[self presentViewController:alert animated:YES completion:nil];
}
@end
