#import <TapSharp/TSCommon.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListItemsController.h>
#import "SUFSettings.h"

// extern NSString* PSDeletionActionKey;

@interface PSEditableListController : HBListItemsController
// -(void)reload;
// -(void)reloadSpecifiers;
-(void)editDoneTapped;
-(BOOL)performDeletionActionForSpecifier:(PSSpecifier*)specifier;
@end

@interface SUFManageController : PSEditableListController  {
	BOOL _isEditingMode;
}
// @property(retain, nonatomic) NSArray *faces;
@property(retain, nonatomic) NSArray *faceSpecifiers;
-(PSSpecifier *)createSpecifierFromString:(NSString *)str;
-(void)addFace:(NSString *)face;
-(void)removeFace:(PSSpecifier *)specifier;
-(void)updateFace:(NSString *)face atIndex:(NSIndexPath *)indexPath;
-(IBAction)showAddFaceAlert:(id)sender;
-(void)showEditFaceAlert:(NSIndexPath *)indexPath;
-(void)showManageAlert:(BOOL)editing indexPath:(NSIndexPath *)indexPath;
@end


@implementation SUFManageController
- (id)specifiers {
	if (_specifiers == nil) {
        NSMutableArray *specifiers = [NSMutableArray new];

        for (NSString* face in [UFSettings faces]) {
            if (IsEmptyString(face) == NO) {
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

-(void)addFace:(NSString *)face {
    tslog("SUFManageController:addFace: called: %@", face);
    NSMutableArray *faces = [[UFSettings faces] mutableCopy];
	[faces insertObject:face atIndex:0];
    [UFSettings updateKey:@"faces" value:[faces copy]];
	[self reloadSpecifiers];
}

-(void)removeFace:(PSSpecifier *)specifier {
    tslog("SUFManageController:removeFace: called: %@", specifier);
    NSMutableArray *faces = [[UFSettings faces] mutableCopy];
	[faces removeObjectAtIndex:[faces indexOfObject:[specifier identifier]]];
    [UFSettings updateKey:@"faces" value:[faces copy]];
	[self reloadSpecifiers];
}

-(void)updateFace:(NSString *)face atIndex:(NSIndexPath *)indexPath {
    tslog("SUFManageController:updateFace: called: %@", face);
    NSMutableArray *faces = [[UFSettings faces] mutableCopy];
	[faces replaceObjectAtIndex:indexPath.row withObject:face];
    [UFSettings updateKey:@"faces" value:[faces copy]];
	[self reloadSpecifiers];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:YES];

    if (editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                              target:self
                                                                                              action:@selector(showAddFaceAlert:)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


-(IBAction)showAddFaceAlert:(id)sender {
    tslog("SUFManageController:showAddFaceAlert: called: %@", sender);
    [self showManageAlert:NO indexPath:nil];
}

-(IBAction)showEditFaceAlert:(NSIndexPath *)indexPath {
    tslog("SUFManageController:showEditFaceAlert: called: %@", indexPath);
    [self showManageAlert:YES indexPath:indexPath];
}

-(void)showManageAlert:(BOOL)editing indexPath:(NSIndexPath *)indexPath {
    NSString *title = editing ? @"Edit" : @"Add";

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *addButton = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(id action) {
        NSString* face = ((UITextField*)alert.textFields[0]).text;
        if (IsEmptyString(face) || (editing && face == [[UFSettings faces] objectAtIndex:indexPath.row])) {
            return;
        }

        if (editing) {
            [self updateFace:face atIndex:indexPath];
            [alert dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self addFace:face];
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self editDoneTapped];
        }
    }];

	UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(id action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];

	[alert addAction:addButton];
	[alert addAction:cancelButton];
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"Enter custom face";
		textField.keyboardType = UIKeyboardTypeDefault;

        if (editing) {
    		textField.text = [[UFSettings faces] objectAtIndex:indexPath.row];
        }
	}];

	[self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self showEditFaceAlert:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)performDeletionActionForSpecifier:(PSSpecifier*)specifier {
    tslog("SUFManageController:performDeletionActionForSpecifier: called: %@", specifier);
	@try {
		[super performDeletionActionForSpecifier:specifier];
	} @catch (NSException* exception) {
		NSMutableArray* specifiers = [_specifiers mutableCopy];
		[specifiers removeObjectAtIndex:[_specifiers indexOfObject:specifier]];
		_specifiers = [specifiers copy];
	}
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return tableView.editing ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != [UFSettings faces].count;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to {
    tslog("SUFManageController:tableView:moveRowAtIndexPath:toIndexPath called: %@ %@", from, to);
    NSMutableArray *faces = [[UFSettings faces] mutableCopy];
    NSString* face = [[UFSettings faces] objectAtIndex:from.row];

    [faces removeObjectAtIndex:from.row];
    [faces insertObject:face atIndex:to.row];

    [UFSettings updateKey:@"faces" value:[faces copy]];
	[self reloadSpecifiers];
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)from toProposedIndexPath:(NSIndexPath *)to {
    if (to.row < [UFSettings faces].count) {
        return to;
    }

    return [NSIndexPath indexPathForRow:([UFSettings faces].count - 1) inSection:0];
}

-(void)editDoneTapped {
    tslog("SUFManageController:editDoneTapped: called");
	[super editDoneTapped];

	_isEditingMode = _isEditingMode == NO;

	[self setEditing:_isEditingMode animated:YES];

    [UFSettings updateKey:@"faces" value:[UFSettings faces]];
	[self reloadSpecifiers];
}
@end
