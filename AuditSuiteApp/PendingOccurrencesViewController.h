//
//  PendingOccurrencesCellViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityAlertView.h"
#import "UIView+Presentation.h"

@interface PendingOccurrencesViewController : UIViewController <UITableViewDelegate>
{
	NSMutableArray *_occurrences;
	ActivityAlertView *_loader;
    UITableView *_tableView;
    UIView *_totalsView; 
    UILabel *_overdue;
    UILabel *_today;
    UILabel *_next;
	UILabel *_currentUserLabel;
	UILabel *_currentVersionLabel;
	NSIndexPath *_firstOfToday;
}

@property (nonatomic, strong) NSMutableArray *occurrences;
@property (nonatomic, strong) ActivityAlertView *loader;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *totalsView;
@property (nonatomic, strong) IBOutlet UILabel *overdue;
@property (nonatomic, strong) IBOutlet UILabel *today;
@property (nonatomic, strong) IBOutlet UILabel *next;
@property (nonatomic, strong) IBOutlet UILabel *currentUserLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentVersionLabel;
@property (nonatomic, strong) IBOutlet UIView *refreshView;
@property (nonatomic, strong) IBOutlet UIView *logoutView;
@property (nonatomic, strong) NSIndexPath *firstOfToday;

- (IBAction)refreshPendingOccurrences:(id)sender;
- (IBAction)logout:(id)sender;

@end
