//
//  OccurrenceViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPAPendingOccurrence.h"
#import "ActivityAlertView.h"
#import "UIView+Presentation.h"
#import "OccurrenceCellViewController.h"
#import "DueDateCommentViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

@interface OccurrenceViewController : UIViewController  <DueDateCommentViewControllerDelegate, OccurrenceCellViewControllerDelegate>
{
	ActivityAlertView *_loader;
	IPAPendingOccurrence *_pendingOccurrence;
    UIView *_headerView;  
	UITableView *_tableView;
	CGFloat animatedDistance;
	UILabel *_currentVersionLabel;
	User *currentUser;
	bool useSaveAndExit;
}

@property (nonatomic, strong) ActivityAlertView *loader;
@property (nonatomic, strong) IPAPendingOccurrence *pendingOccurrence;
@property (nonatomic, strong) NSMutableArray *observations;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;


@property (nonatomic, strong) IBOutlet UILabel *dueDate;
@property (nonatomic, strong) NSDate *originalDueDate;
@property (nonatomic, strong) IBOutlet UILabel *area;
@property (nonatomic, strong) IBOutlet UILabel *type;
@property (nonatomic, strong) IBOutlet UILabel *focus;
@property (nonatomic, strong) IBOutlet UITextView *instruction;
@property (nonatomic, strong) IBOutlet UILabel *obs;
@property (nonatomic, strong) IBOutlet UILabel *frequency;
@property (nonatomic, strong) IBOutlet NSString *count;
@property (nonatomic, strong) IBOutlet UILabel *currentVersionLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentUserLabel;
@property (nonatomic, strong) IBOutlet UIButton *addDueDateComment;
@property (nonatomic, strong) IBOutlet UILabel *leadAuditor;
@property (nonatomic, strong) DueDateCommentViewController *dueDateCommentView;
@property (nonatomic, strong) UIPopoverController *dueDateCommentPopover;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) NSIndexPath *firstPendingObservation;
@property (nonatomic, strong) IBOutlet UILabel *auditId;
@property (nonatomic, assign) NSInteger index;
- (void) SaveAndExit;
- (id)initWithPendingOccurrence:(IPAPendingOccurrence *)thePendingOcc;
- (IBAction)DueDateCommentAction:(id)sender;

@end
