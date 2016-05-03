//
//  UIViewController+InternalQPEntryViewController.h
//  AuditSuiteApp
//
//  Created by hz-yumec-mac on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Foundation/Foundation.h"
#import "ActivityAlertView.h"
//#import "UIView+Presentation.h"
#import "LMBSlidingViewController.h"
#import "IPAObservation.h"

@interface InternalQPEntryViewController: LMBSlidingViewController <UIAlertViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _partNumberRecordsFound;
    BOOL _duplicatedOrderRecordsFound;
    NSInteger _materialID;
    NSInteger _manufacturingOrderId;
    NSString *_serverPath;
    IPAObservation *_theObservation;
}

@property (nonatomic, strong) ActivityAlertView *loader;

@property (nonatomic, strong) NSMutableArray *samtecPartNumberArray;

@property (nonatomic, strong) UISearchBar *samtecPartNumberSearchBar;
@property (nonatomic, strong) IBOutlet UITextField *orderNumber;
@property (nonatomic, strong) IBOutlet UITextField *lineNumber;

@property (nonatomic, strong) IBOutlet UITextField *samtecPartNumber;
@property (nonatomic, strong) IBOutlet UITableView *samtecPartNumberTableView;

@property (nonatomic, strong) IBOutlet UITableView *parentDefectCategoryTableView;
@property (nonatomic, strong) NSMutableArray *parentDefectCategoryArray;

@property (nonatomic, strong) IBOutlet UITableView *defectCategoryTableView;
@property (nonatomic, strong) NSMutableArray *defectCategoryArray;

@property (nonatomic, strong) IBOutlet UITableView *defectTableView;
@property (nonatomic, strong) NSMutableArray *defectArray;

@property (nonatomic, strong) IBOutlet UITableView *reportedDefectTableView;
@property (nonatomic, strong) NSMutableArray *reportedDefectArray;

@property (nonatomic, strong) IBOutlet UITextField *totalQuantityInspected;
@property (nonatomic, strong) IBOutlet UITextField *totalQuanityNonconforming;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIButton *saveAndExit;

@property (nonatomic, strong) IBOutlet UITextView *iQPDescription;
@property (nonatomic, strong) IBOutlet UITextField *vendorPOOrderNumber;
@property (nonatomic, strong) IBOutlet UITextField *vendorPOLineNUmber;
@property (nonatomic, strong) IBOutlet UITextField *issueID;

@property (nonatomic, strong) IBOutlet UILabel *samtecPartNumberMessage;

@property (nonatomic, strong) IBOutlet UIView *duplicatedOrderView;
@property (nonatomic, strong) IBOutlet UITableView *duplicatedOrderTableView;
@property (nonatomic, strong) NSMutableArray *duplicatedOrderArray;
@property (nonatomic, strong) IBOutlet UIButton *duplicatedCancel;
@property (nonatomic, strong) IBOutlet UIButton *duplicatedContinue;
@property (nonatomic, strong) IBOutlet UILabel *duplicatedTitle;

@property (nonatomic, strong) IBOutlet UILabel *message;

@property (nonatomic, strong) IBOutlet UILabel *defaultMessage;
@property (nonatomic, strong) IBOutlet UILabel *defaultMessageVendorPO;

@property (nonatomic, strong) IBOutlet UIView *toolingView;
@property (nonatomic, strong) IBOutlet UITextField *machine;
@property (nonatomic, strong) IBOutlet UITextField *process;
@property (nonatomic, strong) IBOutlet UITextField *tool;
@property (nonatomic, strong) IBOutlet UITextField *contactName;

-(id) initWithObServation:(IPAObservation *)theObservation;

- (IBAction) searchSamtecPartNumber:(id)sender;
- (IBAction) searchDuplicatedOrder;
- (IBAction) saveAndExit:(id)sender;

- (void)dismissKeyboard;
- (void) displayInfoAlert: (NSString *) title WithMessage: (NSString *) message;

- (BOOL) validatePage: (NSInteger) categoryId;
- (BOOL) validateIssueID;
- (BOOL) validateOrder;
- (BOOL) validateOrderAndPartNumber: (NSInteger) orderNumber WithLineNumber:(NSInteger) lineNumber;
- (BOOL) validateVendor;
- (BOOL) validatePartNumber;
- (BOOL) validateToolingQPDescription;
- (void) TrimmingCharacters;

- (NSInteger) getDefaultWorkCenterID;
- (NSInteger) getWorkCenterIDByDescription: (NSString *) description;
- (NSInteger) getWorkCenterIDByOrderLineNumber: (NSInteger) orderNumber WithLineNumber: (NSInteger) lineNumber;

- (NSInteger) getReviewBoardAdminIDFormWorkCenterID: (NSInteger) workCenterID;
- (NSInteger) getFacilityIDFormWorkCenterID: (NSInteger) workCenterID;
- (NSInteger) getFacilityIDByUserMasterID: (NSInteger) userMasterID;
- (NSString *) getNextBusinessDateByFacilityId: (NSDate *) initialDate : (NSInteger) facilityID : (NSInteger) daysOffSet;
- (void) clearAllItems;
- (IBAction) duplidatedCancelButton;
- (IBAction) duplidatedContinueButton;
- (BOOL) isUserInGroup: (NSInteger) userMasterId WithDescription: (NSString *) groupDescription;
- (NSInteger) getDefaultInvestigationIdFromWorkCenter:(NSInteger) workCenterMasterId;

@end
