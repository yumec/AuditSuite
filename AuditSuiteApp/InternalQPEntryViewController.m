//
//  UIViewController+InternalQPEntryViewController.m
//  AuditSuiteApp
//
//  Created by hz-yumec-mac on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InternalQPEntryViewController.h"
#import "User.h"
#import "LogonViewController.h"
#import "AppDelegate.h"
#import "ActivityAlertView.h"
#import "SBJSON.h"
#import "QuartzCore/QuartzCore.h"
#import "RecentDefectCellViewController.h"
#import "IPAIQPRecentDefect.h"
#import "OccurrenceViewController.h"
#import "PendingOccurrencesViewController.h"
#import "Defect.h"
#import "NSString+URLEscapes.h"

@implementation InternalQPEntryViewController

@synthesize loader = _loader;
@synthesize samtecPartNumberArray = _samtecPartNumberArray;

@synthesize samtecPartNumberSearchBar = _samtecPartNumberSearchBar;
@synthesize orderNumber = _orderNumber;
@synthesize lineNumber = _lineNumber;
@synthesize samtecPartNumber = _samtecPartNumber;
@synthesize samtecPartNumberTableView = _samtecPartNumberTableView;

@synthesize parentDefectCategoryArray = _parentDefectCategoryArray;
@synthesize parentDefectCategoryTableView = _parentDefectCategoryTableView;

@synthesize defectCategoryArray = _defectCategoryArray;
@synthesize defectCategoryTableView = _defectCategoryTableView;

@synthesize defectArray = _defectArray;
@synthesize defectTableView = _defectTableView;

@synthesize reportedDefectArray = _reportedDefectArray;
@synthesize reportedDefectTableView = _reportedDefectTableView;

@synthesize totalQuantityInspected = _totalQuantityInspected;
@synthesize totalQuanityNonconforming = _totalQuanityNonconforming;

@synthesize scrollView = _scrollView;

@synthesize saveAndExit = _saveAndExit;

@synthesize description = _description;

@synthesize vendorPOOrderNumber = _vendorPOOrderNumber;
@synthesize vendorPOLineNUmber = _vendorPOLineNUmber;

@synthesize issueID = _issueID;

@synthesize samtecPartNumberMessage = _samtecPartNumberMessage;

@synthesize duplicatedOrderView = _duplicatedOrderView;
@synthesize duplicatedOrderTableView = _duplicatedOrderTableView;
@synthesize duplicatedOrderArray = _duplicatedOrderArray;
@synthesize duplicatedCancel = _duplicatedCancel;
@synthesize duplicatedContinue = _duplicatedContinue;
@synthesize duplicatedTitle = _duplicatedTitle;

@synthesize message = _message;
@synthesize defaultMessage = _defaultMessage;
@synthesize defaultMessageVendorPO = _defaultMessageVendorPO;

@synthesize toolingView = _toolingView;
@synthesize machine = _machine;
@synthesize tool = _tool;
@synthesize process = _process;
@synthesize contactName = _contactName;

- (id)init
{
	NSString *nibName =@"InternalQPEntryViewController";
	
	self = [super initWithNibName:nibName bundle:nil];
	
	return self;	
}

-(id) initWithObServation:(IPAObservation *)theObservation
{
    NSString *nibName =@"InternalQPEntryViewController";
	
	self = [super initWithNibName:nibName bundle:nil];
    
    _theObservation = theObservation;
    
	return self;
}

- (void) becomeActive:(NSNotification *) notification {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentUser:nil];
    if (![self isEqual:[self.navigationController visibleViewController]]) {
        UINavigationController *navController = self.navigationController;
        UIViewController *controller = [navController.viewControllers objectAtIndex:0];
        [navController popToViewController:controller animated:YES];
    } 
    [self viewDidAppear:true];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.navigationItem.title = @"IQP Entry";
    self.loader = [[ActivityAlertView alloc] initWithMessage:@"IQP Entry..."];
    
//    self.samtecPartNumberSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.samtecPartNumberTableView.frame.size.width, 37)];
//    self.samtecPartNumberSearchBar.delegate = self;
//    self.samtecPartNumberSearchBar.placeholder = @"Enter Samtec Part Number";
//    self.samtecPartNumberSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.samtecPartNumberSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"SamtecPartNumber", @"Description", nil];
//    self.samtecPartNumberSearchBar.showsScopeBar = YES;
//    self.samtecPartNumberTableView.tableHeaderView = self.samtecPartNumberSearchBar;
//    self.samtecPartNumberSearchBar.tintColor = [UIColor orangeColor];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.scrollView.contentSize = CGSizeMake(768, 1210);
    } else {
        self.scrollView.contentSize = CGSizeMake(980, 1210);
    }
    
    self.scrollView.scrollEnabled = YES;
    [self.scrollView flashScrollIndicators];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView makeShadow];
    [self.iQPDescription configureViewWithBorderColor:[UIColor orangeColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
    [self.toolingView configureViewWithBorderColor:[UIColor orangeColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
    [self.parentDefectCategoryTableView makeCornersRound];
    [self.defectCategoryTableView makeCornersRound];
    [self.defectTableView makeCornersRound];
    [self.reportedDefectTableView makeCornersRound];
    [self.samtecPartNumberTableView makeCornersRound];
    [self.duplicatedOrderView makeCornersRound];
//    [self.duplicatedOrderTableView makeCornersRound];
    
//    [self.saveAndExit configureViewWithBorderColor:[UIColor orangeColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
    [self.saveAndExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveAndExit.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.saveAndExit setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                              stretchableImageWithLeftCapWidth:8.0f
                                              topCapHeight:0.0f]
                                    forState:UIControlStateNormal];
    self.saveAndExit.titleLabel.shadowColor = [UIColor orangeColor];
    self.saveAndExit.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [self.duplicatedContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.duplicatedContinue.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.duplicatedContinue setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                          stretchableImageWithLeftCapWidth:8.0f
                                          topCapHeight:0.0f]
                                forState:UIControlStateNormal];
    self.duplicatedContinue.titleLabel.shadowColor = [UIColor orangeColor];
    self.duplicatedContinue.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [self.duplicatedCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.duplicatedCancel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.duplicatedCancel setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                          stretchableImageWithLeftCapWidth:8.0f
                                          topCapHeight:0.0f]
                                forState:UIControlStateNormal];
    self.duplicatedCancel.titleLabel.shadowColor = [UIColor orangeColor];
    self.duplicatedCancel.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //view to catch  tap
    UIView *view = [[UIView alloc] init];
    
    //leave the navigation bar alone
    view.frame = CGRectMake(0, 0, screenWidth, screenHeight-60);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [view addGestureRecognizer:tap];
    
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
     
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
    
    if (u == nil) {
        LogonViewController *logon = [[LogonViewController alloc] init];
        
        logon.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:logon animated:YES completion:^{}];
        return;
    }
    
    [self.loader show];
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loadData
{
    _serverPath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath];
    
    self.defaultMessage.text = @"(Sample Order & Line No: 244177-21)";
    self.defaultMessageVendorPO.text = @"(Sample Vendor PO & Line No: 473470-1)";
    
    /*
    NSString *orderLineString = @"244177-21";
    self.orderLineNumber.text = orderLineString;
    NSArray *orderLineArray = [orderLineString componentsSeparatedByString:@"-"];
    _orderNumber = [[orderLineArray objectAtIndex:0] integerValue];
    _lineNumber = [[orderLineArray objectAtIndex:1] integerValue];
    
     
    // Load samtecPartNumber by order and line number
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPSamtecPartNumberByOrderLineNumber?orderNumber=%d&lineNumber=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], _orderNumber, _lineNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *samtecPartNumber = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    self.samtecPartNumber.text = [samtecPartNumber stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    */
    
    // Load ParentDefectCategory
    SBJSON *parser = [[SBJSON alloc] init];
    NSString *pdcAddress = [NSString stringWithFormat:@"%@GetInProcessAuditIQPDefectCategory?ParentDefectCategoryId=0", _serverPath];
    NSURLRequest *pdcRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:pdcAddress]];
    NSData *pdcResponse = [NSURLConnection sendSynchronousRequest:pdcRequest returningResponse:nil error:nil];
    NSString *pdc_json_string = [[NSString alloc] initWithData:pdcResponse encoding:NSUTF8StringEncoding];
    NSArray *pdcArray = [parser objectWithString:pdc_json_string error:nil];
    self.parentDefectCategoryArray = [NSMutableArray arrayWithCapacity:[pdcArray count]];
    for (NSDictionary *pdc in pdcArray) {
        [self.parentDefectCategoryArray addObject:pdc];
    }
    
    self.reportedDefectArray = [NSMutableArray arrayWithCapacity:20];
    
    [self performSelectorOnMainThread:@selector(finish)
						   withObject:nil
						waitUntilDone:NO];
}

- (void) finish
{
    [self.samtecPartNumberTableView reloadData];
    [self.parentDefectCategoryTableView reloadData];
    [self.loader close];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.samtecPartNumberTableView) {
        return _partNumberRecordsFound ? self.samtecPartNumberArray.count : 1 ;
    } else if (tableView == self.parentDefectCategoryTableView) {
        return self.parentDefectCategoryArray.count;
    } else if (tableView == self.defectCategoryTableView) {
        return self.defectCategoryArray.count;
    } else if (tableView == self.defectTableView) {
        return self.defectArray.count;
    } else if (tableView == self.reportedDefectTableView){
        return self.reportedDefectArray.count;
    } else if (tableView == self.duplicatedOrderTableView){
        return _duplicatedOrderRecordsFound ? self.duplicatedOrderArray.count : 1;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (tableView == self.duplicatedOrderTableView) {
        title = [NSString stringWithFormat:@"Order/line %@-%@ already exists.", self.orderNumber.text, self.lineNumber.text];
        self.duplicatedTitle.text = title;
    }
    return title;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (tableView == self.duplicatedOrderTableView) {
        
        if (!_duplicatedOrderRecordsFound) {
            UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
            if (emptyCell == nil) {
                emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
            }
            
            emptyCell.textLabel.font = [UIFont systemFontOfSize:32];
            emptyCell.textLabel.text = @"No duplicate records found";
            
            return emptyCell;
            
        } else {
            NSString *nibName = @"RecentDefectCellViewController";
            RecentDefectCellViewController *cell = (RecentDefectCellViewController *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
                for (id currentObjects in topLevelObjects) {
                    if ([currentObjects isKindOfClass:[UITableViewCell class]]) {
                        cell = (RecentDefectCellViewController *) currentObjects;
                        break;
                    }
                }
            }
            
            IPAIQPRecentDefect *i = [self.duplicatedOrderArray objectAtIndex:indexPath.row];
            
            cell.qualityConcernId.text = [NSString stringWithFormat:@"%d", (int)i.qualityConcernId];
            cell.isInternal.text = [NSString stringWithFormat:@"%@", i.isInternal ? @"Internal" : @"External"];
            cell.dateEntered.text = i.dateEntered;
            cell.enteredBy.text = i.enteredBy;
            cell.status.text = i.status;
            cell.samtecPartMasterDescription.text = i.samtecPartMasterDescription;
            cell.defect.text = i.defect;
            cell.defectsCount.text = [NSString stringWithFormat:@"%d", (int)i.defectsCount];
            cell.purchaseOrderNumber.text = i.purchaseOrderNumber;
            cell.orderNumber.text = [NSString stringWithFormat:@"%d", (int)i.orderNumber];
            cell.pcMfgOrderNum.text = [NSString stringWithFormat:@"%d", (int)i.pcMfgOrderNum];
            cell.lineNumber.text = [NSString stringWithFormat:@"%d", (int)i.lineNumber];
            cell.quantityShipped.text = [NSString stringWithFormat:@"%d", (int)i.quantityShipped];
//            cell.submitedByLocationId.text = [NSString stringWithFormat:@"%d", i.submitedByLocationId];
            cell.submitedByLocationName.text = i.submitedByLocationName;
//            cell.reportingCustomerId.text = [NSString stringWithFormat:@"%d", i.reportingCustomerId];
            cell.reportingCustomerName.text = i.reportingCustomerName;
            
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (tableView == self.samtecPartNumberTableView) {
            if (!_partNumberRecordsFound) {
                cell.textLabel.text = @"No records found";
            } else {
                cell.textLabel.text = [self.samtecPartNumberArray objectAtIndex:indexPath.row];
            }
        } else if (tableView == self.parentDefectCategoryTableView) {
            cell.textLabel.text = [[self.parentDefectCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Description"];
        } else if (tableView == self.defectCategoryTableView) {
            cell.textLabel.text = [[self.defectCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Description"];
        } else if (tableView == self.defectTableView) {
            Defect *d = [self.defectArray objectAtIndex:indexPath.row];
            cell.textLabel.text = d.description;
        } else if (tableView == self.reportedDefectTableView) {
            Defect *d = [self.reportedDefectArray objectAtIndex:indexPath.row];
            cell.textLabel.text = d.allDescription;
            UIImage *image = [UIImage imageNamed:@"delete.png"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(0, 0, 18, 18);
            button.frame = frame;
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(deleteReportDefect:) forControlEvents:UIControlEventTouchUpInside]; 
            button.tag = indexPath.row;
            cell.accessoryView = button;
        }
        
        return cell;
    }
}

- (void) deleteReportDefect:(id)sender
{
    NSInteger row = ((UIControl *) sender).tag;
    [self.defectArray addObject:[self.reportedDefectArray objectAtIndex:row]];
    [self.reportedDefectArray removeObjectAtIndex:row];
    [self.defectTableView reloadData];
    [self.reportedDefectTableView reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];
    
    if (tableView == self.samtecPartNumberTableView) {
        self.samtecPartNumber.text = [self.samtecPartNumberArray objectAtIndex:indexPath.row];
        self.samtecPartNumberMessage.text = @"";
        
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulseAnimation.duration = 0.8;
        pulseAnimation.autoreverses = NO;
        pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        pulseAnimation.toValue = [NSNumber numberWithFloat:0.0];
        self.samtecPartNumberTableView.alpha = 0.0;
        [self.samtecPartNumberTableView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
    } else if (tableView == self.parentDefectCategoryTableView) {
        
        NSInteger parentDefectCategoryId =[[[self.parentDefectCategoryArray objectAtIndex:indexPath.row] valueForKey:@"DefectCategoryId"] integerValue];
        
        // Load DefectCategory
        SBJSON *parser = [[SBJSON alloc] init];
        NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPDefectCategory?ParentDefectCategoryId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)parentDefectCategoryId];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSArray *result = [parser objectWithString:json_string error:nil];
        [self.defectCategoryArray removeAllObjects];
        self.defectCategoryArray = [NSMutableArray arrayWithCapacity:result.count];
        for (NSDictionary *d in result) {
            [self.defectCategoryArray addObject:d];
        }
        [self.defectArray removeAllObjects];
        [self.defectTableView reloadData];
        [self.defectCategoryTableView reloadData];
    } else if (tableView == self.defectCategoryTableView) {
        NSInteger defectCategoryId =[[[self.defectCategoryArray objectAtIndex:indexPath.row] valueForKey:@"DefectCategoryId"] integerValue];
        // Load Defect
        SBJSON *parser = [[SBJSON alloc] init];
        NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPDefect?DefectCategoryId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)defectCategoryId];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSArray *result = [parser objectWithString:json_string error:nil];
        [self.defectArray removeAllObjects];
        self.defectArray = [NSMutableArray arrayWithCapacity:result.count];
        for (NSDictionary *d in result) {
            Defect *temp = [Defect defectWithDictionary:d];
            [self.defectArray addObject:temp];
        }
        
        [self.defectTableView reloadData];
    } else if (tableView == self.defectTableView ) {
        [self.reportedDefectArray addObject:[self.defectArray objectAtIndex:indexPath.row]];
        [self.defectArray removeObjectAtIndex:indexPath.row];
        [self.defectTableView reloadData];
        [self.reportedDefectTableView reloadData];
    } else if (tableView == self.reportedDefectTableView) {
        [self.defectArray addObject:[self.reportedDefectArray objectAtIndex:indexPath.row]];
        [self.reportedDefectArray removeObjectAtIndex:indexPath.row];
        [self.defectTableView reloadData];
        [self.reportedDefectTableView reloadData];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.duplicatedOrderTableView) {
        return 104.0;
    } else {
        return 22.0;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.duplicatedOrderTableView) {
        cell.backgroundColor = [UIColor lightTextColor];
    } else if (indexPath.row % 2 == 0) {
        UIColor *col = [UIColor colorWithRed:0.95 green:0.91 blue:0.86 alpha:1.0];
		cell.backgroundColor = col;
    }
}

- (void) dismissKeyboard
{
    CABasicAnimation *pulseAnimationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimationFade.duration = 0.8;
    pulseAnimationFade.autoreverses = NO;
    pulseAnimationFade.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimationFade.toValue = [NSNumber numberWithFloat:0.0];

    
    if ([self.totalQuantityInspected isFirstResponder]) {
        [self.totalQuantityInspected resignFirstResponder];
    } else if ([self.totalQuanityNonconforming isFirstResponder]) {
        [self.totalQuanityNonconforming resignFirstResponder];
    } else if ( [self.orderNumber isFirstResponder]) {
        [self.orderNumber resignFirstResponder];
    } else if ( [self.lineNumber isFirstResponder]) {
        [self.lineNumber resignFirstResponder];
    } else if ([self.samtecPartNumber isFirstResponder]) {
        [self.samtecPartNumber resignFirstResponder];
    } else if ([self.vendorPOOrderNumber isFirstResponder]) {
        [self.vendorPOOrderNumber resignFirstResponder];
    } else if ([self.vendorPOLineNUmber isFirstResponder]) {
        [self.vendorPOLineNUmber resignFirstResponder];
    } else if ([self.issueID isFirstResponder]) {
        [self.issueID resignFirstResponder];
    } else if ([self.iQPDescription isFirstResponder]) {
        [self.iQPDescription resignFirstResponder];
    } else if ([self.tool isFirstResponder]) {
        [self.tool resignFirstResponder];
    } else if ([self.machine isFirstResponder]) {
        [self.machine resignFirstResponder];
    } else if ([self.process isFirstResponder]) {
        [self.process resignFirstResponder];
    } else if ([self.contactName isFirstResponder]) {
        [self.contactName resignFirstResponder];
    } 
    
    if (self.samtecPartNumberTableView.alpha == 1.0) {
        self.samtecPartNumberTableView.alpha = 0;
        [self.samtecPartNumberTableView.layer addAnimation:pulseAnimationFade forKey:@"SelectAnimation"];
    } 
    
//    if (self.duplicatedOrderView.alpha == 1.0) {
//        self.duplicatedOrderView.alpha = 0;
//        [self.duplicatedOrderView.layer addAnimation:pulseAnimationFade forKey:@"SelectAnimation"];
//    }
    
    if (self.toolingView.alpha == 1.0) {
        self.toolingView.alpha = 0;
        [self.toolingView.layer addAnimation:pulseAnimationFade forKey:@"SelectAnimation"];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    [super textFieldDidBeginEditing:textField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    if (self.orderNumber.text.length > 0 && textField == self.lineNumber && textField.text.length > 0) {
        if ([self validateOrder]) {
            [self searchDuplicatedOrder];
        }
    } else if (textField == self.issueID && textField.text.length > 0) {
        [self validateIssueID];
    } else if (self.vendorPOOrderNumber.text.length > 0 && textField == self.vendorPOLineNUmber && self.duplicatedOrderView.alpha == 0 && textField.text.length > 0) {
        [self validateVendor];
    }

    [super textFieldDidEndEditing:textField]; 
}

- (IBAction)searchSamtecPartNumber:(id)sender
{
    NSString *partNumber = [self.samtecPartNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (partNumber.length < 3) {
        self.samtecPartNumberMessage.text = @"Part Number must more than 3 characters.";
        return;
    }
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimation.duration = 0.8;
    pulseAnimation.autoreverses = NO;
    pulseAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    
    SBJSON *paser = [[SBJSON alloc] init];
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPMatchingPartNumber?SamtecPartNumber=%@", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], partNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *result = [paser objectWithString:json_string error:nil];
    _partNumberRecordsFound = result.count > 0;
    [self.samtecPartNumberArray removeAllObjects];
    self.samtecPartNumberArray = [NSMutableArray arrayWithCapacity:result.count];
    for (NSDictionary *dict in result) {
        [self.samtecPartNumberArray addObject:[dict valueForKey:@"SamtecPartNumber"]];
    }
    
    self.samtecPartNumberTableView.alpha = 1.0;
    [self.samtecPartNumberTableView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
    
    [self.samtecPartNumberTableView reloadData];
    
    self.samtecPartNumberMessage.text = [NSString stringWithFormat:@"%d part number show below.", (int)self.samtecPartNumberArray.count];
}

- (IBAction) searchDuplicatedOrder
{
    SBJSON *parser = [[SBJSON alloc] init];
    
	NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPRecentDefects?orderID=%d&LineNumber=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)[self.orderNumber.text integerValue], (int)[self.lineNumber.text integerValue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	NSArray *result = [parser objectWithString:json_string error:nil];
    _duplicatedOrderRecordsFound = result.count > 0;
    [self.duplicatedOrderArray removeAllObjects];
    
    if (_duplicatedOrderRecordsFound) {
        self.duplicatedOrderArray = [NSMutableArray arrayWithCapacity:result.count];
        
        for (NSDictionary *d in result) {
            IPAIQPRecentDefect *temp = [IPAIQPRecentDefect IPAIQPRecentDefectWithDictionary:d];
            [self.duplicatedOrderArray addObject:temp];
        }
        
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulseAnimation.duration = 0.8;
        pulseAnimation.autoreverses = NO;
        pulseAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.0];
        self.duplicatedOrderView.alpha = 1.0;
        [self.duplicatedOrderView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
        [self.duplicatedOrderTableView reloadData];
    }
    
}

- (IBAction) saveAndExit:(id)sender {
    
    self.loader = [[ActivityAlertView alloc] initWithMessage:@"Please Wait..."];
//    [self TrimmingCharacters];
    
    User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
    
    BOOL isSP = NO; // Purchasing
    BOOL isInv = NO; // System Audit
    BOOL isVendor = NO; // Vendor
    BOOL isIssue = NO; // Issue
    
    BOOL isPacking = NO; // Packaging
    BOOL isEng = NO; // Engineering
    BOOL isCEGASP = NO; // CEGASP
    BOOL isTooling = NO; // Tooling QP
    BOOL isIEEng = NO; // IE(Industrial Engineering)
    
    BOOL isQPAssociates = NO;
    // add by yumec in 2013-05-14 after QP new ruld chagne.
    BOOL isScrapTracking= NO;
    BOOL isToolingTransition = NO;
    
    NSInteger aCategoryId = 0;
    if (self.reportedDefectArray.count > 0) {
        for (NSDictionary *a in self.reportedDefectArray) {
            if ([[a valueForKey:@"defectCategoryId"] integerValue] == 34)
            {
                aCategoryId = 34; // categoryId = 34, categoryDesc = Tooling
                isTooling = YES;
            }
            if ([[a valueForKey:@"parentDefectCategoryId"] integerValue] == 71) {
                isInv = YES; // categoryId = 71, categoryDesc = System Audit
            }
            if ([[a valueForKey:@"defectCategoryId"] integerValue] == 69) {
                isSP = YES; // categoryId = 69, categoryDesc = Purchasing
            }
            if ([[a valueForKey:@"parentDefectCategoryId"] integerValue] == 1) {
                isPacking = YES; // categoryId = 1, categoryDesc = Packaging
            }
            if ([[a valueForKey:@"parentDefectCategoryId"] integerValue] == 14) {
                isEng = YES; // categoryId = 14, categoryDesc = Engineering
            }
            if ([[a valueForKey:@"defectCategoryId"] integerValue] == 35) {
                isCEGASP = YES; // categoryId = 35, categoryDesc = CEGASP
            }
            if ([[a valueForKey:@"defectCategoryId"] integerValue] == 88) {
                isIEEng = YES; // categoryId = 88, categoryDesc = IE(Industrial Engineering)
            }
            if ([[a valueForKey:@"defectCategoryId"] integerValue] == 105) {
                isScrapTracking = YES; // categoryId = 105, categoryDesc = Scrap Tracking
            }
            if ([[a valueForKey:@"defectCategoryId"] integerValue] == 100) {
                isToolingTransition = YES; // categoryId = 100, categoryDesc = Tooling Transition Group
            }
        }
    }

    if (![self validatePage:aCategoryId]) {
        return;
    }
    
    [self.loader show];
    
    if (self.vendorPOOrderNumber.text.length > 0 && self.vendorPOLineNUmber.text.length > 0 && [self validateVendor]) {
        isVendor = YES;
    }
    
    if (self.issueID.text.length > 0 && [self validateIssueID]) {
        isIssue = YES;
    }
    
    // Set Plant Info: ReportingPlantId = 4, Desc = In House Connectors NA
    // NSInteger reportingPlantId = 4;
    
    // Set Working Info
    NSInteger lastWorkCenterId = 0;
    
    if (isVendor) {
        lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP Supplier"];
    } else if (isSP) {
        lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP Purchasing"];
    } else if (isInv) {
        lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP System Audit"];
    } else if (isPacking) {
        lastWorkCenterId = [self getWorkCenterIDByOrderLineNumber:[self.orderNumber.text integerValue] WithLineNumber: [self.lineNumber.text integerValue]];
        lastWorkCenterId = lastWorkCenterId != 0 ? lastWorkCenterId : [self getWorkCenterIDByDescription:@"QP Packaging"]; 
    } else if (isEng) {
        if (isCEGASP) {
            lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP ASP"];
        } else if(isIEEng) {
            lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP IND ENG"];
        } else if(isTooling) {
            if (isToolingTransition) {
                lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP TRANSITION GROUP TOOLING"];
            } else {
                lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP Tooling"];
            }
        } else {
            lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP Engineering"];
        }
    } else if (isScrapTracking) {
        lastWorkCenterId = [self getWorkCenterIDByDescription:@"QP SCRAP AUDIT TRACKING"];
    }
    else if (!isIssue) {
        lastWorkCenterId = [self getWorkCenterIDByOrderLineNumber:[self.orderNumber.text integerValue] WithLineNumber: [self.lineNumber.text integerValue]];
    } else {
        lastWorkCenterId = [self getDefaultWorkCenterID];
    }
    
    // Assign Responsible User
    NSInteger responsibleUserId = 0;
    responsibleUserId = [self getReviewBoardAdminIDFormWorkCenterID:lastWorkCenterId];
    if (responsibleUserId == 0) {
        lastWorkCenterId = [self getDefaultWorkCenterID];
    }
    
    // Set Default Facility Info
    NSInteger reportingFacilityId = 0;
    reportingFacilityId = [self getFacilityIDFormWorkCenterID:lastWorkCenterId];
    if (reportingFacilityId == 0) {
        reportingFacilityId = [self getFacilityIDByUserMasterID:u.userMasterId];
    }
    
    NSInteger issueID = 0;
    if (self.issueID.text.length > 0) {
        issueID = [self.issueID.text integerValue];
    }
    
    NSInteger defaultDueDateOffSet = 6;
    NSString *dueDate = [self getNextBusinessDateByFacilityId:[NSDate date] :reportingFacilityId : defaultDueDateOffSet];
    
    NSString *addressSave = [NSString stringWithFormat:@"%@InProcessAuditIQPQualityConcernSave?Description=%@&MaterialId=%d&DateDue=%@&SamtecPartNumber=%@&ResponsibleUserId=%d&ReportedDefectCount=%d&InspectedDefectCount=%d&LastWorkCenterId=%d&EnteredById=%d&ModifiedById=%d&ReportingPlantId=%d&IssueID=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], self.iQPDescription.text, (int)_materialID, dueDate, self.samtecPartNumber.text, (int)responsibleUserId, (int)[self.totalQuanityNonconforming.text integerValue], (int)[self.totalQuantityInspected.text integerValue], (int)lastWorkCenterId, (int)u.userMasterId, (int)u.userMasterId, (int)reportingFacilityId, (int)issueID];
    addressSave = [addressSave stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *requestSave = [NSURLRequest requestWithURL:[NSURL URLWithString: addressSave]];
    NSData *responseSave = [NSURLConnection sendSynchronousRequest:requestSave returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:responseSave encoding:NSUTF8StringEncoding];
    if (result.length > 0) {
        NSInteger qualityConcernId = [result integerValue];
        _theObservation.qualityConcernId = qualityConcernId; // Update qualityConcernId in Obervation page
        // Insert ManufacturingOrderLink
        if (self.orderNumber.text.length > 0 && self.lineNumber.text.length > 0) {
            NSString *orderLineNumber = [NSString stringWithFormat:@"%@-%@", self.orderNumber.text, self.lineNumber.text];
            NSString *address = [NSString stringWithFormat:@"%@InProcessAuditIQPManufacturingOrderLinkInsert?QualityConcernId=%d&ManufacturingOrderId=%d&ManufacturingOrderLineNo=%@&EnteredById=%d&ModifiedById=%d", _serverPath, (int)qualityConcernId , (int)_manufacturingOrderId, orderLineNumber, (int)u.userMasterId, (int)u.userMasterId];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        }
        
        // Insert VendorPOLink
        if (self.vendorPOOrderNumber.text.length > 0 && self.vendorPOLineNUmber.text.length > 0) {
            NSString *vendorPOOrderLineNumber = [NSString stringWithFormat:@"%@-%@",self.vendorPOOrderNumber.text, self.vendorPOLineNUmber.text];
            NSString *address = [NSString stringWithFormat:@"%@InProcessAuditIQPVendorPOLinkInsert?QualityConcernId=%d&VendorPOId=%d&VendorPOLineNo=%@&EnteredById=%d", _serverPath, (int)qualityConcernId , (int)[self.vendorPOOrderNumber.text integerValue], vendorPOOrderLineNumber, (int)u.userMasterId];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        }
        
        // Insert ReportDefect
        if (self.reportedDefectArray.count > 0) {
            for (NSDictionary *d in self.reportedDefectArray) {
                NSString *address = [NSString stringWithFormat:@"%@InProcessAuditIQPReportedDefectInsert?QualityConcernId=%d&DefectId=%d&EnteredById=%d&ModifiedById=%d&VendorId=0", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)qualityConcernId , (int)[[d valueForKey:@"defectId"] integerValue] , (int)u.userMasterId, (int)u.userMasterId];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
                [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            } 
            
        }
        
        // Update InProcessAuditIQPObservationId
        NSString *address = [NSString stringWithFormat:@"%@InProcessAuditIQPObservationUpdate?QualityConcernId=%d&ObservationId=%d", _serverPath, (int)qualityConcernId , (int)_theObservation.observationId];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        // Assign default investigation
        isQPAssociates = [self isUserInGroup:u.userMasterId WithDescription:@"QualityProblemAssociate"];
        if (isQPAssociates && !isInv) {
            NSInteger defaultInvestigatorId = [self getDefaultInvestigationIdFromWorkCenter:lastWorkCenterId];
            NSString *dateDue = [self getNextBusinessDateByFacilityId:[NSDate date] :reportingFacilityId : 3];
            NSString *address = [NSString stringWithFormat:@"%@InProcessAuditIQPInvestigationRequestInsert?QualityConcernId=%d&ResponsibleUserId=%d&DateDue=%@&EnteredById=%d&ModifiedById=%d", _serverPath, (int)qualityConcernId , (int)defaultInvestigatorId, dateDue, (int)u.userMasterId, (int)u.userMasterId];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
      
//        UINavigationController* navController = self.navigationController;
//        UIViewController* controller = [navController.viewControllers objectAtIndex:1];
//        [navController popToViewController:controller animated:YES];
        
    } else {
        [self displayInfoAlert:@"Unable to create QP" WithMessage:@"Please contact Help-Desk MIS."];
    }
    
    [self.loader close];
    [self clearAllItems];
    
}

- (void) displayInfoAlert: (NSString *) title WithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:title];
	[alert setMessage:message];
	[alert addButtonWithTitle:@"Close"];
	[alert show];
}


- (void) TrimmingCharacters
{
    self.orderNumber.text = [self.orderNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.lineNumber.text = [self.lineNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.vendorPOOrderNumber.text = [self.vendorPOOrderNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.vendorPOLineNUmber.text = [self.vendorPOLineNUmber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.issueID.text = [self.issueID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.samtecPartNumber.text = [self.samtecPartNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.iQPDescription.text = [[self.iQPDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] escapedURLString] ;
    self.totalQuanityNonconforming.text = [self.totalQuanityNonconforming.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.totalQuantityInspected.text = [self.totalQuantityInspected.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL) validatePage: (NSInteger)categoryId
{
    BOOL allValid = YES;
    
    [self TrimmingCharacters];

    if (allValid && categoryId != 34 && self.orderNumber.text.length == 0 && self.lineNumber.text.length == 0 && self.vendorPOOrderNumber.text.length == 0 && self.vendorPOLineNUmber.text.length == 0 && self.issueID.text.length == 0) {
        self.message.text = @"Manufacturing Order or VendorPO or Issue ID should be entered.";
        allValid = NO;       
    } 
    
    if (allValid && self.samtecPartNumber.text.length == 0) {
        self.message.text = @"Invalid Samtec Part Number.";
        allValid = NO;
    }
    
    if (allValid && self.reportedDefectArray.count == 0) {
        self.message.text = @"Please select a Defect.";
        allValid = NO;
    }
    
    if (allValid && self.totalQuantityInspected.text.length == 0) {
        self.message.text = @"Please re-enter inspected total.";
        allValid = NO;
    }
    if (allValid && self.totalQuanityNonconforming.text.length == 0) {
        self.message.text = @"Please re-enter defect total.";
        allValid = NO;
    }
    
    if (allValid && [self.totalQuantityInspected.text integerValue] < [self.totalQuanityNonconforming.text integerValue]) {
        self.message.text = @"Inspected total must be greater than defect total.";
        allValid = NO;
    }
    
    if (allValid && categoryId != 34 && self.iQPDescription.text.length == 0) {
        self.message.text = @"Please enter Description.";
        allValid = NO;
    } 
    
    if (allValid && categoryId == 34) {
        allValid = [self validateToolingQPDescription];
    }
    
    if (allValid && self.orderNumber.text.length > 0 && self.lineNumber.text.length > 0 && ![self validateOrder]) {
        self.message.text = @"Invalid Order Number.";
        allValid = NO;
    }
    
    if (allValid && self.vendorPOOrderNumber.text.length > 0 && self.vendorPOLineNUmber.text.length > 0 && ![self validateVendor]) {
        self.message.text = @"Invalid Vendor PO.";
        allValid= NO;
    }
    
    if (allValid && self.issueID.text.length > 0 && ![self validateIssueID]) {
        self.message.text = @"Invalid Issue ID.";
        allValid = NO;
    }
        
    if (allValid && self.samtecPartNumber.text.length > 0 && ![self validatePartNumber]) {
        self.message.text = @"Invalid Samtec Part Number.";
        allValid = NO;
    }
    
    if (allValid) {
        self.message.text = @"";
    }
    
    return allValid;
}

- (BOOL) validateIssueID 
{
    BOOL issueIDValid = NO;
    self.message.text = @"";
    
    self.issueID.text = [self.issueID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.issueID.text.length > 0) {
        // Load samtecPartNumber by issueID
        NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPSamtecPartNumberByIssueID?IssueID=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)[self.issueID.text integerValue]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *samtecPartNumber = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        samtecPartNumber = [samtecPartNumber stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if (samtecPartNumber.length > 0) {
            self.samtecPartNumber.text = samtecPartNumber;
            self.orderNumber.text = @"";
            self.lineNumber.text = @"";
            self.vendorPOOrderNumber.text = @"";
            self.vendorPOLineNUmber.text = @"";
            issueIDValid = YES;
        } else {
            self.issueID.text = @"Invalid Issue ID.";
            self.issueID.text = @"";
            issueIDValid = NO;
        }
    } else {
        self.issueID.text = @"Invalid Issue ID.";
        self.issueID.text = @"";
        issueIDValid = NO;
    }
    return issueIDValid;
}

- (BOOL) validateOrder
{
    BOOL validateOrder = NO;
    self.message.text = @"";
    
    if (self.orderNumber.text.length > 0 && self.lineNumber.text.length > 0) {
        
        if ([self validateOrderAndPartNumber:[self.orderNumber.text integerValue] WithLineNumber: [self.lineNumber.text integerValue]]) {

            // Load Samtec Part Number by Order and Line Number.
            NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPSamtecPartNumberByOrderLineNumber?orderNumber=%d&lineNumber=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)[self.orderNumber.text integerValue], (int)[self.lineNumber.text integerValue]];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *samtecPartNumber = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            self.samtecPartNumber.text = [samtecPartNumber stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            self.issueID.text = @"";
            self.vendorPOOrderNumber.text = @"";
            self.vendorPOLineNUmber.text = @"";
            validateOrder = YES;
        } else {
            self.message.text = @"Invalid manufacturing order number.";
            self.orderNumber.text = @"";
            self.lineNumber.text = @"";
            validateOrder = NO;
        }
    } else {
        self.message.text = @"Invalid manufacturing order number.";
        self.orderNumber.text = @"";
        self.lineNumber.text = @"";
        validateOrder = NO;
    }
    
    return validateOrder;
}

- (BOOL) validateOrderAndPartNumber: (NSInteger) orderNumber WithLineNumber:(NSInteger)lineNumber
{
    // Load ManufacturingOrderId by order and line number.
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPManufacturingOrderIdByOrderLineNumber?OrderNumber=%d&LineNumber=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)orderNumber, (int)lineNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    _manufacturingOrderId = [result integerValue];
    if (_manufacturingOrderId > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) validateVendor
{
    BOOL validateVendor = NO;
    self.message.text = @"";

    if (self.vendorPOOrderNumber.text.length > 0 && self.vendorPOLineNUmber.text.length > 0) {
        SBJSON *parser = [[SBJSON alloc] init];
        NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPSamtecPartNumberByVendorPOLineNumber?VendorPONumber=%d&lineNumber=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)[self.vendorPOOrderNumber.text integerValue] , (int)[self.vendorPOLineNUmber.text integerValue]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
        NSArray *result = [parser objectWithString:json_string error:nil];
        if (result.count > 0) {
            self.samtecPartNumber.text = [[result objectAtIndex:0] valueForKey:@"SamtecPartNumber"];
            self.orderNumber.text = @"";
            self.lineNumber.text = @"";
            self.issueID.text = @"";
            validateVendor = YES;
        } else {
            self.message.text = @"Invalid Vendor PO.";
            self.vendorPOOrderNumber.text = @"";
            self.vendorPOLineNUmber.text = @"";
            validateVendor = NO;
        }
    } else {
        self.message.text = @"Invalid Vendor PO.";
        self.vendorPOOrderNumber.text = @"";
        self.vendorPOLineNUmber.text = @"";
        validateVendor = NO;
    }
    return validateVendor;
}


- (BOOL) validatePartNumber
{
    BOOL validatePartNumber = NO;
    
    NSString *partNumber = [self.samtecPartNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (partNumber.length > 0) {
        // Get MaterialID
        User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
        
        SBJSON *parser = [[SBJSON alloc] init];
        NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPMaterial?PartNumber=%@&UserMasterID=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], self.samtecPartNumber.text, (int)u.userMasterId];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
        NSArray *result = [parser objectWithString:json_string error:nil];
        
        if (result.count > 0) {
            _materialID = [[[result objectAtIndex:0] objectForKey:@"MaterialID"] integerValue];
            validatePartNumber = YES;
        } else {
            self.message.text = @"Invalid Part Number.";
            validatePartNumber = NO;
        }
        
    } else {
        self.message.text = @"Invalid Part Number.";
        validatePartNumber = NO;
    }
    
    return validatePartNumber;                                                               
}

- (BOOL) validateToolingQPDescription
{
    BOOL validate = YES;
    
    if (self.toolingView.alpha == 0) {
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        pulseAnimation.duration = 0.8;
        pulseAnimation.autoreverses = NO;
        pulseAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.0];
        [self.toolingView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
        self.toolingView.alpha = 1.0;
    }
    
    if (validate && self.tool.text.length == 0) {
        self.message.text = @"Tool can not be empty!";
        validate = NO;
    }
    if (validate && self.process.text.length == 0) {
        self.message.text = @"Process can not be empty!";
        validate = NO;
    }
    if (validate && self.contactName.text.length == 0) {
        self.message.text = @"Contact Name can not be empty!";
        validate = NO;
    }
    
    if (validate) {
        NSString *description = nil;
        description = [NSString stringWithFormat:@"Machine #: %@, ", self.machine.text];
        description = [description stringByAppendingFormat:@"Tool #: %@, ", self.tool.text];
        description = [description stringByAppendingFormat:@"Process: %@, ", self.process.text];
        description = [description stringByAppendingFormat:@"Contact Name: %@.", self.contactName.text];
        if (self.iQPDescription.text.length == 0) {
            self.iQPDescription.text = [self.iQPDescription.text stringByAppendingFormat:@"%@",description];
        } else {
            self.iQPDescription.text = [self.iQPDescription.text stringByAppendingFormat:@" %@",description];
        }
    }
    
    return validate;
}

- (NSInteger) getDefaultWorkCenterID
{
    NSInteger workCenterID = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPDefaultWorkCenterMasterID", _serverPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    workCenterID = [result integerValue];
    return workCenterID;
}

- (NSInteger) getWorkCenterIDByDescription:(NSString *)description
{
    NSInteger workCenterID = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPWorkCenterMasterIDByDescription?Description=%@", _serverPath, description];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    workCenterID = [result integerValue];
    return workCenterID;
}

- (NSInteger) getWorkCenterIDByOrderLineNumber: (NSInteger) orderNumber WithLineNumber:(NSInteger)lineNumber
{
    NSInteger workCenterID = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPWorkCenterMasterIDByOrderLineNumber?OrderNumber=%d&LineNumber=%d", _serverPath, (int)orderNumber, (int)lineNumber];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (result) {
         workCenterID = [result integerValue];
    }
    return workCenterID;
}

- (NSInteger) getReviewBoardAdminIDFormWorkCenterID: (NSInteger) workCenterID
{
    NSInteger userMasterID = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPReviewBoardAdminIdFormWorkCenterId?WorkCenterId=%d", _serverPath, (int)workCenterID];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (result) {
        userMasterID = [result integerValue];
    }
    return userMasterID;
}

- (NSInteger) getFacilityIDFormWorkCenterID:(NSInteger)workCenterID
{
    NSInteger facilityID = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPFacilityIdFormWorkCenterId?WorkCenterId=%d", _serverPath, (int)workCenterID];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (result) {
        facilityID = [result integerValue];
    }
    return facilityID;
}

- (NSInteger) getFacilityIDByUserMasterID: (NSInteger) userMasterID
{
    NSInteger facilityID = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPFacilityIdByUserMasterId?userMasterId=%d", _serverPath, (int)userMasterID];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (result) {
        facilityID = [result integerValue];
    }
    return facilityID;
}

- (NSString *) getNextBusinessDateByFacilityId: (NSDate *) initialDate : (NSInteger) facilityID : (NSInteger) daysOffSet
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSString *beginDate = [df stringFromDate:initialDate];
    
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPNextBusinessDateByFacilityId?beginDate=%@&FacilityId=%d&DaysOffset=%d", _serverPath, beginDate, (int)facilityID, (int)daysOffSet];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSString *nextBusinessDay = [result stringByReplacingOccurrencesOfString:@"\"" withString:@""]; 
   
    return nextBusinessDay;
}

- (void) clearAllItems
{
    self.orderNumber.text = nil;
    self.lineNumber.text = nil;
    self.vendorPOOrderNumber.text = nil;
    self.vendorPOLineNUmber.text = nil;
    self.issueID.text = nil;
    self.samtecPartNumber.text = nil;
    self.iQPDescription.text = nil;
    self.machine.text = nil;
    self.tool.text = nil;
    self.process.text = nil;
    self.contactName.text = nil;
    [self.reportedDefectArray removeAllObjects];
    [self.reportedDefectTableView reloadData];
}

- (IBAction)duplidatedCancelButton
{
    CABasicAnimation *pulseAnimationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimationFade.duration = 0.8;
    pulseAnimationFade.autoreverses = NO;
    pulseAnimationFade.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimationFade.toValue = [NSNumber numberWithFloat:0.0];
    self.duplicatedOrderView.alpha = 0;
    [self.duplicatedOrderView.layer addAnimation:pulseAnimationFade forKey:@"SelectAnimation"];
    self.orderNumber.text = @"";
    self.lineNumber.text = @"";
    self.samtecPartNumber.text = @"";
}

- (IBAction)duplidatedContinueButton
{
    CABasicAnimation *pulseAnimationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulseAnimationFade.duration = 0.8;
    pulseAnimationFade.autoreverses = NO;
    pulseAnimationFade.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimationFade.toValue = [NSNumber numberWithFloat:0.0];
    self.duplicatedOrderView.alpha = 0;
    [self.duplicatedOrderView.layer addAnimation:pulseAnimationFade forKey:@"SelectAnimation"];
}

- (BOOL) isUserInGroup:(NSInteger)userMasterId WithDescription:(NSString *)groupDescription
{
    BOOL isUserInGroup = NO;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPUserMasterGroupId?UserMasterId=%d&GroupDescription=%@", _serverPath, (int)userMasterId, groupDescription];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if ([result integerValue] > 0) {
        isUserInGroup = YES;
    }
    return isUserInGroup;
}

- (NSInteger) getDefaultInvestigationIdFromWorkCenter:(NSInteger)workCenterMasterId
{
    NSInteger defaultInvestigatorId = 0;
    NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPDefaultInvestigatorIdFormWorkCenterMasterId?WorkCenterMasterId=%d", _serverPath, (int)workCenterMasterId];
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (result) {
        defaultInvestigatorId = [result integerValue];
    }
    return defaultInvestigatorId;
}

@end
