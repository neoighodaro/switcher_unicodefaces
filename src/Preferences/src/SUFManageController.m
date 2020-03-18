#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListItemsController.h>
#import "SUFSettings.h"

// extern NSString* PSDeletionActionKey;

@interface PSEditableListController : HBListItemsController
// -(void)reload;
// -(void)reloadSpecifiers;
-(void)editButtonWasTapped;
// - (BOOL)performDeletionActionForSpecifier:(PSSpecifier*)specifier;
@end

@interface SUFManageController : PSEditableListController  {
	BOOL _isEditingMode;
}
// @property(retain, nonatomic) NSArray *faces;
@property(retain, nonatomic) NSArray *faceSpecifiers;
-(PSSpecifier *)createSpecifierFromString:(NSString *)str;
@end


@implementation SUFManageController
- (id)specifiers {
	if (_specifiers == nil) {
        NSMutableArray *specifiers = [NSMutableArray new];

        for (NSString* face in [UFSettings faces]) {
            if ([TrimString(face) isEqualToString:@""] == NO) {
                [specifiers addObject:[self createSpecifierFromString:face]];
            }
        }

        _specifiers = [specifiers copy];
	}

	return _specifiers;
}

-(PSSpecifier *)createSpecifierFromString:(NSString *)str {
    PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:str
    		target:self set:nil get:nil detail:nil cell:PSListItemCell edit:nil];
    [specifier setProperty:str forKey:@"id"];
    [specifier setProperty:NSStringFromSelector(@selector(removeFace:)) forKey:PSDeletionActionKey];
    return specifier;
}

@end
