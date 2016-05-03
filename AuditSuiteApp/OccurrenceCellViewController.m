//
//  OccurrenceCellViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OccurrenceCellViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "WorkCenter.h"
#import "IPAOBservationAttachedFile.h"
#import "GalleryPhotoCellViewController.h"
#import "NSData+Base64.h"
#import <QuartzCore/QuartzCore.h>
#import "XMLReader.h"
#import "UIImage+fixOrientation.h"
#import "Shift.h"
#import "NSString+URLEscapes.h"

#define DECIMALCHARSET	@"1234567890.,"

@implementation UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end

@implementation OccurrenceCellViewController

@synthesize headerView;
@synthesize headerNotesView;
@synthesize auditeeView;
@synthesize selectedAuditeeView;
@synthesize workCenterView;
@synthesize selectedWorkCenterView;
@synthesize supervisorView;
@synthesize selectedSupervisorView;
@synthesize shiftView;
@synthesize selectedShiftView;
@synthesize selectedDayofView;
@synthesize galleryView;
@synthesize galleryViewEnabled;
@synthesize occurrenceCount;
@synthesize observationValue;
@synthesize statusLabel;
@synthesize selectedAuditeeLabel;
@synthesize selectedWorkCenterLabel;
@synthesize selectedSupervisorLabel;
@synthesize selectedShiftLabel;
@synthesize buttonView;
@synthesize enableTopView;
@synthesize enableBottomView;
@synthesize statusView;
@synthesize editButton;
@synthesize auditeeButton;
@synthesize workCenterButton;
@synthesize supervisorButton;
@synthesize shiftButton;
@synthesize auditeeSearchBar = _auditeeSearchBar;
@synthesize workCenterSearchBar = _workCenterSearchBar;
@synthesize supervisorSearchBar = _supervisorSearchBar;
@synthesize shiftSearchBar = _shiftSearchBar;
@synthesize auditeeImage = _auditeeImage;
@synthesize workCenterImage = _workCenterImage;
@synthesize supervisorImage = _supervisorImage;
@synthesize shiftImage = _shiftImage;
@synthesize observationValueImage = _observationValueImage;
@synthesize generalNotesImage = _generalNotesImage;
@synthesize backgroundImage = _backgroundImage;

@synthesize loader = _loader;
@synthesize observation = _observation;
@synthesize pendingOccurrence = _pendingOccurrence;
@synthesize usersFacility = _usersFacility;
@synthesize workCenters = _workCenters;
@synthesize shiftList = _shiftList;
@synthesize auditeeUsersCopy = _auditeeUsersCopy;
@synthesize workCentersCopy = _workCentersCopy;
@synthesize supervisorUsersCopy	= _supervisorUsersCopy;
@synthesize shiftCopy = _shiftCopy;
@synthesize auditeeTableView = _auditeeTableView;
@synthesize supervisorsTableView = _supervisorsTableView;
@synthesize workCentersTableView = _workCentersTableView;
@synthesize shiftTableView = _shiftTableView;
@synthesize imagesTableView = _imagesTableView;

@synthesize failOptionsView = _failOptionsView;
@synthesize failOptionsPopover = _failOptionsPopover;
@synthesize notCompleteNotesView = _notCompleteNotesView;
@synthesize notCompleteNotesPopover = _notCompleteNotesPopover;

@synthesize index = _index;
@synthesize selectedAuditee = _selectedAuditee;
@synthesize selectedWorkCenter = _selectedWorkCenter;
@synthesize selectedSupervisor = _selectedSupervisor;
@synthesize selectedShift = _selectedShift;
@synthesize enteredObservationValue = _enteredObservationValue;
@synthesize enteredGeneralNotes = _enteredGeneralNotes;

@synthesize loadingPicturesLabel = _loadingPicturesLabel;
@synthesize activityIndicator = _activityIndicator;

@synthesize caller;

@synthesize addInternalQP = _addInternalQP;
@synthesize internalQP = _internalQP;
@synthesize passButton;
@synthesize failButton;
@synthesize notCompleteButton;
@synthesize currentObservationIndex = _currentObservationIndex;

UISwitch *copySelectedWorkCenterSwitch;
UISwitch *copySelectedSupervisorSwitch;
UISwitch *copySelectedShiftSwitch;

- (void)initWithLoadData:(IPAPendingOccurrence *) pendOcc withCaller:(id<OccurrenceCellViewControllerDelegate>) _caller
{	
	self.pendingOccurrence = pendOcc;

//	self.loader = [[ActivityAlertView alloc] initWithMessage:@"Loading Observation..."];
//	[self.loader show];
	
//	[self.loadingPicturesLabel setAlpha:0.0];
//	[self.activityIndicator setAlpha:0.0];
	
	[self.loadingPicturesLabel setAlpha:1.0];
	[self.activityIndicator setAlpha:1.0];
	[self.activityIndicator startAnimating];
	[self.galleryViewEnabled setAlpha:0.14];
	
	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[pulseAnimation setDuration: 0.5];
	[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
	[pulseAnimation setAutoreverses: YES];
	[pulseAnimation setRepeatCount: FLT_MAX];
	[self.loadingPicturesLabel.layer addAnimation:pulseAnimation forKey:@"LoadingPicturesAnimation"];
	
    if (self.observation.qualityConcernId > 0) {
        self.internalQP.text = [NSString stringWithFormat:@"iQP: %d", (int)self.observation.qualityConcernId];
    }
    
	[NSThread detachNewThreadSelector:@selector(loadData)
							 toTarget:self
						   withObject:nil];
	
	self.auditeeSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.auditeeTableView.frame.size.width, 87.0)];
	self.auditeeSearchBar.delegate = self; 
	self.auditeeSearchBar.placeholder = @"Enter Name";
	self.auditeeSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.auditeeSearchBar.showsScopeBar = YES;
    self.auditeeSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Full Name", @"User Id",nil];
    //self.auditeeSearchBar.barTintColor = [UIColor lightGrayColor];
    [self.auditeeSearchBar sizeToFit];
    self.auditeeSearchBar.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.22];
    
    
	self.auditeeTableView.tableHeaderView = self.auditeeSearchBar;
	self.auditeeUsersCopy = [[NSMutableArray alloc] init];
	self.auditeeSearchBar.tag = 0;
	self.auditeeSearchBar.tintColor = [UIColor orangeColor];
	_auditeeSearching = NO;
	
	self.workCenterSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.workCentersTableView.frame.size.width, 87.0)];
	self.workCenterSearchBar.delegate = self; 
	self.workCenterSearchBar.placeholder = @"Enter Description";
	self.workCenterSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.workCenterSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Description", @"Work Center Id",nil];	
	self.workCenterSearchBar.showsScopeBar = YES;
    //self.workCenterSearchBar.barTintColor = [UIColor clearColor];
    [self.workCenterSearchBar sizeToFit];
    self.workCenterSearchBar.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.22];
    
    
	self.workCentersTableView.tableHeaderView = self.workCenterSearchBar;
	self.workCentersCopy = [[NSMutableArray alloc] init];
	self.workCenterSearchBar.tag = 1;
	self.workCenterSearchBar.tintColor = [UIColor orangeColor];
	_workCenterSearching = NO;
	
	self.supervisorSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.supervisorsTableView.frame.size.width, 87.0)]; 
	self.supervisorSearchBar.delegate = self; 
	self.supervisorSearchBar.placeholder = @"Enter Name";
	self.supervisorSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.supervisorSearchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Full Name", @"User Id", nil];
	self.supervisorSearchBar.showsScopeBar = YES;
    //self.supervisorSearchBar.barTintColor = [UIColor clearColor];
    [self.supervisorSearchBar sizeToFit];
    self.supervisorSearchBar.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.22];
    
    self.supervisorsTableView.tableHeaderView = self.supervisorSearchBar;
	self.supervisorUsersCopy = [[NSMutableArray alloc] init];
	self.supervisorSearchBar.tag = 2;
	self.supervisorSearchBar.tintColor = [UIColor orangeColor];
	_supervisorSearching = NO;
    
    UIView *copySelectedWorkCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 253, self.workCenterSearchBar.bounds.size.width, 27)];
    copySelectedWorkCenterView.backgroundColor = [UIColor orangeColor];
    copySelectedWorkCenterSwitch = [[UISwitch alloc]init];
    copySelectedWorkCenterSwitch.onTintColor = [UIColor orangeColor];
    copySelectedWorkCenterSwitch.backgroundColor = [UIColor orangeColor];
    UILabel *copyWorkCenterLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 300, 27)];
    copyWorkCenterLabel.backgroundColor = [UIColor orangeColor];
    copyWorkCenterLabel.text = @"Repeat on all remaining observations";
    copyWorkCenterLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [copySelectedWorkCenterView addSubview:copySelectedWorkCenterSwitch];
    [copySelectedWorkCenterView addSubview:copyWorkCenterLabel];
    [self.workCenterView addSubview:copySelectedWorkCenterView];
    
    UIView *copySelectedSupervisorView = [[UIView alloc] initWithFrame:CGRectMake(0, 253, self.supervisorSearchBar.bounds.size.width, 27)];
    copySelectedSupervisorView.backgroundColor = [UIColor orangeColor];
    copySelectedSupervisorSwitch = [[UISwitch alloc]init];
    copySelectedSupervisorSwitch.onTintColor = [UIColor orangeColor];
    copySelectedSupervisorSwitch.backgroundColor = [UIColor orangeColor];
    UILabel *copyLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 300, 27)];
    copyLabel.backgroundColor = [UIColor orangeColor];
    copyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    copyLabel.text = @"Repeat on all remaining observations";
    [copySelectedSupervisorView addSubview:copySelectedSupervisorSwitch];
    [copySelectedSupervisorView addSubview:copyLabel];
    [self.supervisorView addSubview:copySelectedSupervisorView];
    
    
    UIView *copySelectedShiftView = [[UIView alloc] initWithFrame:CGRectMake(0, 153, 300, 27)];
    copySelectedShiftView.backgroundColor = [UIColor orangeColor];
    copySelectedShiftSwitch = [[UISwitch alloc]init];
    copySelectedShiftSwitch.onTintColor = [UIColor orangeColor];
    copySelectedShiftSwitch.backgroundColor = [UIColor orangeColor];
    UILabel *copyShiftLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 300, 27)];
    copyShiftLabel.backgroundColor = [UIColor orangeColor];
    copyShiftLabel.text = @"Repeat on all remaining observations";
    copyShiftLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [copySelectedShiftView addSubview:copySelectedShiftSwitch];
    [copySelectedShiftView addSubview:copyShiftLabel];
    [self.shiftView addSubview:copySelectedShiftView];
    
	if (self.pendingOccurrence.observationValue.length == 0) {
		
		self.observationValue.text = @"N/A";
		self.enteredObservationValue.enabled = NO;
		self.enteredObservationValue.backgroundColor = [UIColor lightGrayColor];
		self.enteredObservationValue.alpha = 0.5;
	}
	else	
	{
		self.observationValue.text = self.pendingOccurrence.observationValue;
		self.enteredObservationValue.text = self.observation.observationValue;
	}
		
	self.enteredGeneralNotes.text = self.observation.generalNotes;
    
	self.selectedAuditee = [[ObservationInfoViewController alloc] init];
	self.selectedWorkCenter = [[ObservationInfoViewController alloc] init];
	self.selectedSupervisor = [[ObservationInfoViewController alloc] init];
	self.selectedShift = [[ObservationInfoViewController alloc] init];

	self.caller = _caller;
	
	[self.auditeeButton setImage:[UIImage imageNamed:@"rnd_br_next.png"] forState:UIControlStateNormal];
	[self.auditeeButton setImage:[UIImage imageNamed:@"rnd_br_down.png"] forState:UIControlStateSelected];
	[self.auditeeButton setSelected:NO];
	
	[self.workCenterButton setImage:[UIImage imageNamed:@"rnd_br_next.png"] forState:UIControlStateNormal];
	[self.workCenterButton setImage:[UIImage imageNamed:@"rnd_br_down.png"] forState:UIControlStateSelected];
	[self.workCenterButton setSelected:NO];
	
	[self.supervisorButton setImage:[UIImage imageNamed:@"rnd_br_next.png"] forState:UIControlStateNormal];
	[self.supervisorButton setImage:[UIImage imageNamed:@"rnd_br_down.png"] forState:UIControlStateSelected];
	[self.supervisorButton setSelected:NO];
	
	[self.backgroundImage setAlpha: 0.0];
//    [self.auditeeTableView setAlpha:0.0];
//    [self.workCentersTableView setAlpha:0.0];
//    [self.supervisorsTableView setAlpha:0.0];
}

- (NSString *) CanSave
{
	NSString *address = [NSString stringWithFormat:@"%@InProcessAuditCanSaveObservation?id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)self.pendingOccurrence.occurrenceId];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	
	return [NSString stringWithFormat:@"%@", json_string];
}

- (NSString *) CanCancel
{
	NSString *address = [NSString stringWithFormat:@"%@InProcessAuditCanCancelObservation?id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)self.pendingOccurrence.occurrenceId];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	
	return [NSString stringWithFormat:@"%@", json_string];
}

- (NSString *) CanCancelObservationByAuditor: (int) observationId : (int) userMasterId
{
    NSString *address = [NSString stringWithFormat:@"%@InProcessAuditObservationCanCancelByAuditor?ObservationId=%d&UserMasterId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], observationId, userMasterId];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	return [NSString stringWithFormat:@"%@", json_string];
}

- (BOOL) ValidateObservationInfo:(NSString *) validateType
{
	NSString *_resultValidation = @"";
	
	NSInteger _ErrorsCount = 0;
	self.auditeeImage.alpha = 0.0;
	self.workCenterImage.alpha = 0.0;
	self.supervisorImage.alpha = 0.0;
    self.shiftImage.alpha = 0.0;
	self.observationValueImage.alpha = 0.0;
	self.generalNotesImage.alpha = 0.0;
	
	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[pulseAnimation setDuration: 0.8];
	[pulseAnimation setAutoreverses:NO];
	[pulseAnimation setFromValue: [NSNumber numberWithFloat:1.0]];
	[pulseAnimation setToValue: [NSNumber numberWithFloat:0.0]];
	
	if (self.auditeeView.alpha > 0.0) {
		[self.auditeeView setAlpha: 0.0];
		[self.auditeeView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	if (self.workCenterView.alpha > 0.0) {
		[self.workCenterView setAlpha: 0.0];
		[self.workCenterView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	if (self.supervisorView.alpha > 0.0) {
		[self.supervisorView setAlpha: 0.0];
		[self.supervisorView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	self.auditeeButton.selected = NO;
	self.workCenterButton.selected = NO;
	self.supervisorButton.selected = NO;
	
	//Commented by ISSUE IPA-155
//	if (self.observation.auditee.userMasterId < 1) {
//		_ErrorsCount = _ErrorsCount + 1;
//		self.auditeeImage.alpha = 1.0;
//		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//		[pulseAnimation setDuration: 0.5];
//		[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
//		[pulseAnimation setAutoreverses: YES];
//		[pulseAnimation setRepeatCount: 5];
//		[self.auditeeImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
//		_resultValidation = [NSString stringWithFormat:@"%@\nAuditee.",_resultValidation];
//	}
	
	if (self.observation.workCenterId < 1) {
		_ErrorsCount = _ErrorsCount + 1;
		self.workCenterImage.alpha = 1.0;
		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[pulseAnimation setDuration: 0.5];
		[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
		[pulseAnimation setAutoreverses: YES];
		[pulseAnimation setRepeatCount: 5];
		[self.workCenterImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
		_resultValidation = [NSString stringWithFormat:@"%@\nWork Center.",_resultValidation];
	}
	
	if (self.observation.supervisor.userMasterId < 1) {
		_ErrorsCount = _ErrorsCount + 1;
		self.supervisorImage.alpha = 1.0;
		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[pulseAnimation setDuration: 0.5];
		[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
		[pulseAnimation setAutoreverses: YES];
		[pulseAnimation setRepeatCount: 5];
		[self.supervisorImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
		_resultValidation = [NSString stringWithFormat:@"%@\nSupervisor.",_resultValidation];
	}
    
    if (self.observation.shiftId < 1) {
		_ErrorsCount = _ErrorsCount + 1;
		self.shiftImage.alpha = 1.0;
		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[pulseAnimation setDuration: 0.5];
		[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
		[pulseAnimation setAutoreverses: YES];
		[pulseAnimation setRepeatCount: 5];
		[self.shiftImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
		_resultValidation = [NSString stringWithFormat:@"%@\nShift Description.",_resultValidation];
	}
     
	if (![validateType isEqualToString:@"PASS"] && [self.enteredGeneralNotes.text length] == 0) {
		_ErrorsCount = _ErrorsCount + 1;
		self.generalNotesImage.alpha = 1.0;
		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		[pulseAnimation setDuration: 0.5];
		[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
		[pulseAnimation setAutoreverses: YES];
		[pulseAnimation setRepeatCount: 5];
		[self.generalNotesImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
		_resultValidation = [NSString stringWithFormat:@"%@\nGeneral Notes.",_resultValidation];
	}
	
	if (self.pendingOccurrence.observationValue.length > 0) {
		
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		
		NSNumber* number = [numberFormatter numberFromString:self.enteredObservationValue.text];
		
		if (!number) {
			_ErrorsCount = _ErrorsCount + 1;
			self.observationValueImage.alpha = 1.0;
			CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			[pulseAnimation setDuration: 0.5];
			[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
			[pulseAnimation setAutoreverses: YES];
			[pulseAnimation setRepeatCount: 5];
			[self.observationValueImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
			_resultValidation = [NSString stringWithFormat:@"%@\nObservation Value.",_resultValidation];
		}
	}
	
	if (_ErrorsCount > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"Required information is invalid:%@",  _resultValidation]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		
		[alert show];
		return NO;
	}
	return YES;
}

- (BOOL) ValidateObservationInfoNotComplete
{
//	NSString *_resultValidation = @"";
//	
//	NSInteger _ErrorsCount = 0;
	self.auditeeImage.alpha = 0.0;
	self.workCenterImage.alpha = 0.0;
	self.supervisorImage.alpha = 0.0;
	self.observationValueImage.alpha = 0.0;
	self.generalNotesImage.alpha = 0.0;
	
	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[pulseAnimation setDuration: 0.8];
	[pulseAnimation setAutoreverses:NO];
	[pulseAnimation setFromValue: [NSNumber numberWithFloat:1.0]];
	[pulseAnimation setToValue: [NSNumber numberWithFloat:0.0]];
	
	if (self.auditeeView.alpha > 0.0) {
		[self.auditeeView setAlpha: 0.0];
		[self.auditeeView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	if (self.workCenterView.alpha > 0.0) {
		[self.workCenterView setAlpha: 0.0];
		[self.workCenterView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	if (self.supervisorView.alpha > 0.0) {
		[self.supervisorView setAlpha: 0.0];
		[self.supervisorView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	self.auditeeButton.selected = NO;
	self.workCenterButton.selected = NO;
	self.supervisorButton.selected = NO;
	
//	if ([self.enteredGeneralNotes.text length] == 0) {
//		_ErrorsCount = _ErrorsCount + 1;
//		self.generalNotesImage.alpha = 1.0;
//		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//		[pulseAnimation setDuration: 0.5];
//		[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
//		[pulseAnimation setAutoreverses: YES];
//		[pulseAnimation setRepeatCount: 5];
//		[self.generalNotesImage.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
//		_resultValidation = [NSString stringWithFormat:@"%@\nGeneral Notes.",_resultValidation];
//	}
//	
//	if (_ErrorsCount > 0) {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"Required information is blank:%@",  _resultValidation]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//		
//		[alert show];
//		return NO;
//	}
	return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)FailAction:(id)sender
{
    [self findAndResignFirstResponder];
    
    if (self.internalQP.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create QP" message:@"Do you wish to Enter a QP?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO", nil];
        alert.tag = 3;
        [alert show];
    } else {
        self.failOptionsView = [[FailOptionsViewController alloc] initWithCaller:self title:@"New Part" andContext:nil];
        
        if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
            self.failOptionsPopover =[[UIPopoverController alloc]initWithContentViewController:self.failOptionsView];
            
            [self.failOptionsPopover presentPopoverFromRect: CGRectMake(185, 657, 100, 100)
                                                     inView:self
                                   permittedArrowDirections:UIPopoverArrowDirectionDown 
                                                   animated:YES];
        } else
        {
            [self addSubview:[self.failOptionsView view]];
            [[self.failOptionsView view] makeShadow];
        }
    }
}

- (IBAction)NotCompleteNotesAction:(id)sender
{
	[self findAndResignFirstResponder];
	
    self.notCompleteNotesView = [[NotCompleteNotesViewController alloc] initWithCaller:self title:@"New Part" andContext:nil];
    
    
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        self.notCompleteNotesPopover =[[UIPopoverController alloc]initWithContentViewController:self.notCompleteNotesView];
		
        [self.notCompleteNotesPopover presentPopoverFromRect: CGRectMake(330, 657, 100, 100)
												 inView:self
							   permittedArrowDirections:UIPopoverArrowDirectionDown 
											   animated:YES];
		
		[[self.notCompleteNotesView noteTextView] becomeFirstResponder];
    }
    else
    {
        [self addSubview:[self.notCompleteNotesView view]];
        [[self.notCompleteNotesView view] makeShadow];
    }
}

- (IBAction)PassAction:(id)sender
{
	[self findAndResignFirstResponder];
    
	if ([self ValidateObservationInfo:@"PASS"]) {
		self.loader = [[ActivityAlertView alloc] initWithMessage:@"Saving Observation..."];
		[self.loader show];
		User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
		
		NSString *address;
		
		if (self.observation.observationId == 0) {
			NSString *result = [self CanSave];
			if ([result isEqualToString:@"\"VALID\""]) {
				//SAVE
				address = [NSString stringWithFormat:@"%@InProcessAuditObservationSave?User=%d&occ=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d",[(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.pendingOccurrence.occurrenceId,(int)self.selectedAuditee.descriptionId,(int)self.selectedWorkCenter.descriptionId,(int)self.selectedSupervisor.descriptionId,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"PASS",@"",@"", (int)self.selectedShift.descriptionId];
			}else
			{
				//ALert		
				UIAlertView *alert;
				
				if ([result isEqualToString:@"\"PASTDUECOMMENT\""])
				{
					alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					alert.tag = 2;
				}
				else
				{
					alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				}
				
				[self.loader close];
				[alert show];
				return;
			}
		}
		else
		{
			NSString *result = [self CanSave];
			if ([result isEqualToString:@"\"VALID\""]) {
				address = [NSString stringWithFormat:@"%@InProcessAuditObservationUpdate?User=%d&obsId=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.observation.observationId,(int)self.selectedAuditee.descriptionId,(int)self.selectedWorkCenter.descriptionId,(int)self.selectedSupervisor.descriptionId,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"PASS",@"",@"", (int)self.selectedShift.descriptionId];
			}else
			{
				//ALert		
				UIAlertView *alert;
				
				if ([result isEqualToString:@"\"PASTDUECOMMENT\""]) 
				{
					alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					alert.tag = 2;
				}
				else
				{
					alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				}
				
				[self.loader close];
				[alert show];
				return;
			}
		}
		address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
		
		if([json_string integerValue] < 1)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Observation wasn't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[self.loader close];
			[alert show];
		}
		else
		{
			self.observation.observationId = self.observation.observationId == 0? [json_string integerValue] : self.observation.observationId;
			if ([self savePictures]) {
				[self.enableTopView setAlpha:0.4];
				[self.enableBottomView setAlpha:0.4];
				[self.editButton setAlpha:1.0];
				self.statusLabel.text = @"PASS";
				[self.statusView setAlpha:0.8];
                
				[self.caller occurrenceCellSaved:self.currentObservationIndex];
			}
		}
		[self.loader close];
	}
}

- (IBAction)EditAction:(id)sender
{
	
	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[pulseAnimation setDuration: 0.8];
	[pulseAnimation setAutoreverses:NO];
	[pulseAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
	[pulseAnimation setToValue: [NSNumber numberWithFloat:0.0]];
	
	
	if ([self.statusLabel.text isEqualToString:@"INCOMPLETE"] || [self.statusLabel.text isEqualToString:@"CANCELED"] ) {
		[self.enableTopView setAlpha:0.0];
		[self.enableTopView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
		[self.enableBottomView setAlpha:0.0];
		[self.enableBottomView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
		[self.editButton setAlpha:0.0];
		[self.editButton.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
		[self.statusView setAlpha:0.0];
		[self.statusView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	else
	{
		[self.enableBottomView setAlpha:0.0];
		[self.enableBottomView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
		[self.editButton setAlpha:0.0];
		[self.editButton.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
		[self.statusView setAlpha:0.0];
		[self.statusView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
	}
	
	
	 
}

- (IBAction)addIPAObservation:(id)sender
{
	[self.caller occurrenceCellAddObservation:self.currentObservationIndex];
}

- (IBAction) AddInternalQP:(id)sender
{    
    [self.caller occurrenceCellAddIQP:self.observation];
}

- (IBAction)cancelObservations:(id)sender
{
    
    User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
    NSString *canCancelObservationByAuditor = [self CanCancelObservationByAuditor:(int)self.observation.observationId :(int)u.userMasterId];
    
    if ([canCancelObservationByAuditor isEqualToString:@"\"VALID\""]) {
        NSString *result = [self CanCancel];
        if ([result isEqualToString:@"\"VALID\""]) {
            //ALert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Do you really want to cancel current pending observations?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            [alert setTag:1];
            [alert show];
            return;
        }else
        {
            //ALert
            UIAlertView *alert;
            
            if ([result isEqualToString:@"\"PASTDUECOMMENT\""])
            {
                alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                alert.tag = 2;
            }
            else
            {
                alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            }
            
            [alert show];
            return;
        }
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"You don't have permision to cancel current observation. Please contact your team leader to cancel." delegate:sender cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert setTag:4];
        [alert show];
        return;
    }
    
	
}

- (IBAction)SelectAWCSAction:(id)sender
{
	UIButton *_button = (UIButton *) sender;
	
	_button.selected = !_button.selected;
	
	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[pulseAnimation setDuration: 0.8];
	[pulseAnimation setAutoreverses:NO];
	[pulseAnimation setFromValue:[NSNumber numberWithFloat:_button.selected? 0.0 : 1.0]];
	[pulseAnimation setToValue: [NSNumber numberWithFloat:_button.selected? 1.0 : 0.0]];
	
	
	CABasicAnimation *pulseAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[pulseAnimation2 setDuration: 0.8];
	[pulseAnimation2 setAutoreverses:NO];
	[pulseAnimation2 setFromValue:[NSNumber numberWithFloat:_button.selected? 1.0 : 0.0]];
	[pulseAnimation2 setToValue: [NSNumber numberWithFloat:_button.selected? 0.0 : 1.0]];
	
	switch (_button.tag) {
		case 0:
			[self.auditeeView setAlpha: _button.selected? 1.0 : 0.0];
			[self.auditeeView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
			
			if (self.workCenterView.alpha > 0.0) {
				[self.workCenterView setAlpha: 0.0];
				[self.workCenterView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.workCenterSearchBar resignFirstResponder];
			}
			if (self.supervisorView.alpha > 0.0) {
				[self.supervisorView setAlpha: 0.0];
				[self.supervisorView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.supervisorSearchBar resignFirstResponder];
			}
            if (self.shiftView.alpha > 0.0) {
                [self.shiftView setAlpha: 0.0];
				[self.shiftView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
            }
			
			self.workCenterButton.selected = NO;
			self.supervisorButton.selected = NO;
			self.shiftButton.selected = NO;

			if (_button.selected) 
			{
				[self.auditeeSearchBar becomeFirstResponder];
			}
			else
			{
				[self.auditeeSearchBar resignFirstResponder];
			}
			break;
			
		case 1:
			[self.workCenterView setAlpha: _button.selected? 1.0 : 0.0];
			[self.workCenterView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
			
			if (self.auditeeView.alpha > 0.0) {
				[self.auditeeView setAlpha: 0.0];
				[self.auditeeView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.auditeeSearchBar resignFirstResponder];
			}
			if (self.supervisorView.alpha > 0.0) {
				[self.supervisorView setAlpha: 0.0];
				[self.supervisorView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.supervisorSearchBar resignFirstResponder];
			}

            if (self.shiftView.alpha > 0.0) {
                [self.shiftView setAlpha: 0.0];
				[self.shiftView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
            }
            
			self.auditeeButton.selected = NO;
			self.supervisorButton.selected = NO;
			self.shiftButton.selected = NO;

			if (_button.selected) 
			{
				[self.workCenterSearchBar becomeFirstResponder];
			}
			else
			{
				[self.workCenterSearchBar resignFirstResponder];
			}
			break;
			
		case 2:
			[self.supervisorView setAlpha: _button.selected? 1.0 : 0.0];
			[self.supervisorView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
			
			if (self.workCenterView.alpha > 0.0) {
				[self.workCenterView setAlpha: 0.0];
				[self.workCenterView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.workCenterSearchBar resignFirstResponder];
			}
			if (self.auditeeView.alpha > 0.0) {
				[self.auditeeView setAlpha: 0.0];
				[self.auditeeView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.auditeeSearchBar resignFirstResponder];
			}
            
            if (self.shiftView.alpha > 0.0) {
                [self.shiftView setAlpha: 0.0];
				[self.shiftView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
            }

			self.auditeeButton.selected = NO;
			self.workCenterButton.selected = NO;
			self.shiftButton.selected = NO;

			if (_button.selected) 
			{
				[self.supervisorSearchBar becomeFirstResponder];
			}
			else
			{
				[self.supervisorSearchBar resignFirstResponder];
			}
			break;
        case 3: //Shift
			[self.shiftView setAlpha: _button.selected? 1.0 : 0.0];
			[self.shiftView.layer addAnimation:pulseAnimation forKey:@"SelectAnimation"];
			
            if (self.auditeeView.alpha > 0.0) {
				[self.auditeeView setAlpha: 0.0];
				[self.auditeeView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.auditeeSearchBar resignFirstResponder];
			}
            
			if (self.workCenterView.alpha > 0.0) {
				[self.workCenterView setAlpha: 0.0];
				[self.workCenterView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.workCenterSearchBar resignFirstResponder];
			}
			if (self.supervisorView.alpha > 0.0) {
				[self.supervisorView setAlpha: 0.0];
				[self.supervisorView.layer addAnimation:pulseAnimation2 forKey:@"SelectAnimation"];
				[self.supervisorSearchBar resignFirstResponder];
			}
            
			self.auditeeButton.selected = NO;
			self.workCenterButton.selected = NO;
			self.supervisorButton.selected = NO;

			break;
	}
}


#pragma mark -
#pragma mark Threading Messages

- (void)loadData
{
    self.shiftTableView.tag =  4;
    self.shiftButton.tag = 3;
    
	User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];

	SBJSON *parser = [[SBJSON alloc] init];
	
	NSString *address = [NSString stringWithFormat:@"%@GetUsersByFacility?id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId];
 
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	NSArray *users = [parser objectWithString:json_string error:nil];
	
	self.usersFacility = [NSMutableArray arrayWithCapacity:[users count]];
	
	for(NSDictionary *us in users)
	{
		User *tmp = [User userWithDictionary:us];
		[self.usersFacility addObject:tmp];
	}
	
	address = [NSString stringWithFormat:@"%@GetWorkCenters", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath]];
	request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	NSArray *wc = [parser objectWithString:json_string error:nil];
	
	self.workCenters = [NSMutableArray arrayWithCapacity:[wc count]];
	
	for(NSDictionary *w in wc)
	{
		WorkCenter *tmp = [WorkCenter workCenterWithDictionary:w];
		[self.workCenters addObject:tmp];
	}
    
    
    address = [NSString stringWithFormat:@"%@GetShift", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath]];
	request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	NSArray *sl = [parser objectWithString:json_string error:nil];
	
	self.shiftList = [NSMutableArray arrayWithCapacity:[sl count]];
	
	for(NSDictionary *s in sl)
	{
		Shift *tmp = [Shift shiftWithDictionary:s];
		[self.shiftList addObject:tmp];
	}
    
    
	if (self.observation.observationId > 0) { 
        
        [self.observation.images removeAllObjects];
        self.observation.images = [NSMutableArray arrayWithCapacity:1];
        
		address = [NSString stringWithFormat:@"%@GetFileGroupIdByObservationId?id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)self.observation.observationId];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
		
		response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	

        
		if([json_string integerValue] > 0)
		{
            [self loadPicture:[json_string integerValue]];  
		}
        
        if (self.observation.qualityConcernId > 0) {
            address = [NSString stringWithFormat:@"%@GetInProcessAuditIQPFileGroupIdByQPId?QualityConcernId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)self.observation.qualityConcernId];
            
            request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
            
            response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            if([json_string integerValue] > 0)
            {
                [self loadPicture:[json_string integerValue]];
            }
        }
		
		[self.galleryViewEnabled setAlpha:0.0];
		[self.activityIndicator stopAnimating];
		[self.loadingPicturesLabel.layer removeAnimationForKey:@"LoadingPicturesAnimation"];
		[self.loadingPicturesLabel setAlpha:0.0];
		[self.activityIndicator setAlpha:0.0];
		
		if ([self.observation.images count] == 0) {
			self.observation.images = [NSMutableArray arrayWithCapacity:0];
			[self.backgroundImage setAlpha:1.0];
		}
		else
		{
			[self.backgroundImage setAlpha:0.0];
		}
	}
	else
	{
		if ([self.observation.images count] == 0) {
			self.observation.images = [NSMutableArray arrayWithCapacity:0];
			[self.backgroundImage setAlpha:1.0];
		}
		else
		{
			[self.backgroundImage setAlpha:0.0];
		}
	}
	
	[self performSelectorOnMainThread:@selector(finish) 
						   withObject:nil 
						waitUntilDone:NO];
}

- (void) loadPicture:(NSInteger)fileGroupID
{
    NSString *urlString = [NSString stringWithFormat:@"%@fileGroupId/%d/active/Y", [(AppDelegate *)[[UIApplication sharedApplication] delegate] fileManagementServerPath], (int)fileGroupID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *xml_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    if (xml_string) {
        NSError *parseError = nil;
        /*
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:xml_string error:&parseError];
        
        NSDictionary* fileDetails = [NSDictionary dictionaryWithDictionary:[xmlDictionary objectForKey:@"ArrayOfFileDetailDataContract"]];
        
        NSArray* dataDetails;
        if([[fileDetails objectForKey:@"FileDetailDataContract"] isKindOfClass:[NSArray class]]){
            //Is array
            dataDetails = [[NSArray alloc] initWithArray:[fileDetails objectForKey:@"FileDetailDataContract"]];
        }else if([[fileDetails objectForKey:@"FileDetailDataContract"] isKindOfClass:[NSDictionary class]]){
            //is dictionary
            dataDetails = [NSArray arrayWithObject:[fileDetails objectForKey:@"FileDetailDataContract"]];
        }
        */
        NSArray *dataDetails = [NSJSONSerialization JSONObjectWithData:[xml_string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
        
        if (dataDetails.count > 0) {
            
//            self.observation.images = [NSMutableArray arrayWithCapacity:[dataDetails count]];

            for(NSDictionary *DataDetail in dataDetails)
            {
//                NSDictionary* detailId = [NSDictionary dictionaryWithDictionary:[DataDetail objectForKey:@"FileDetailId"]];
//                NSString *detailIdValue = [detailId valueForKey:@"text"];
                NSString *detailIdValue = [DataDetail objectForKey:@"FileDetailId"];
                
                NSString *urlString = [NSString stringWithFormat:@"%@fileDetailId/%@", [(AppDelegate *)[[UIApplication sharedApplication] delegate] fileManagementServerPath], detailIdValue];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
                
                NSError *requestError;
                NSURLResponse *urlResponse;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
				
                if (requestError == nil) {
                    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) urlResponse;
                        int status = (int)[httpResponse statusCode];
                        // if the call was okay
                        if ((status >= 200) && (status < 300)) {
                            
                            IPAObservationAttachedFile *tempAttached = [IPAObservationAttachedFile alloc];
                            tempAttached.observationAttachedFileId = [detailIdValue integerValue];
//                            tempAttached.observationAttachedFileId = [[detailId valueForKey:@"text"] integerValue];
//                            tempAttached.fileNotes = [DataDetail objectForKey:@"FileDescription"];
                            tempAttached.observationId = self.observation.observationId;
                            
                            tempAttached.fileData = [UIImage imageWithData:responseData];
                            
                            tempAttached.fileNotes = [DataDetail objectForKey:@"FileDescription"];
                            
                            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                                
                                NSDictionary *headers = [httpResponse allHeaderFields];
                                
                                NSString *imageName = [headers valueForKey:@"Content-Disposition"];
                                
                                if (imageName) {
                                    
                                    NSRange imageNameRange = [imageName rangeOfString:@"\"" options:NSCaseInsensitiveSearch];
                                    NSRange imageTypeRange = [imageName rangeOfString:@"." options:NSBackwardsSearch];
                                    NSRange imageNameRangeEnd = [imageName rangeOfString:@"\"" options:NSBackwardsSearch];
                                    imageNameRange.length = imageTypeRange.location - (imageNameRange.location + 1);
                                    imageTypeRange.length = imageNameRangeEnd.location - (imageTypeRange.location + 1);
                                    imageNameRange.location++;
                                    imageTypeRange.location++;
                                    
//                                    tempAttached.fileNotes = [imageName substringWithRange:imageNameRange];
                                    tempAttached.fileType = [imageName substringWithRange:imageTypeRange];
                                }
                                else
                                {
//                                    tempAttached.fileNotes = @"Picture";
                                    tempAttached.fileType = @"jpeg";
                                }
                            }
                            else
                            {
//                                tempAttached.fileNotes = @"Picture";
                                tempAttached.fileType = @"jpeg";
                            }
                            
                            if ([[tempAttached.fileType uppercaseString] isEqualToString:@"JPEG"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"JPG"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"PNG"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"BMP"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"GIF"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"TIF"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"TIFF"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"JPE"] ||
                                [[tempAttached.fileType uppercaseString] isEqualToString:@"JFIF"]
                                ) {
                                [self.observation.images addObject:tempAttached];
                            }
                        }
                    }
                }	
            }
        }
    }
}

- (void)finish
{
	[self.auditeeTableView reloadData];
	[self.supervisorsTableView reloadData];
	[self.workCentersTableView reloadData];
	[self.imagesTableView reloadData];
	[self.shiftTableView reloadData];
    
	if (self.observation.auditee.userMasterId > 0) {
		self.selectedAuditee.description.text = self.observation.auditee.fullName;
		self.selectedAuditee.descriptionId = self.observation.auditee.userMasterId;
		self.selectedAuditeeLabel.text = self.observation.auditee.fullName;
	}
	
	if (self.observation.workCenterId > 0) {
		for (id f in self.workCenters)
		{
			if ([f workCenterId] == self.observation.workCenterId)
			{
				WorkCenter *wc = (WorkCenter *)f;
				self.selectedWorkCenter.description.text = wc.description;
				self.selectedWorkCenter.descriptionId = wc.workCenterId;
				self.selectedWorkCenterLabel.text = wc.description;
				self.observation.workCenterId = wc.workCenterId;
				
				break;
			}
		}
	}
	
	if (self.observation.supervisor.userMasterId > 0) {
		self.selectedSupervisor.description.text = self.observation.supervisor.fullName;
		self.selectedSupervisor.descriptionId = self.observation.supervisor.userMasterId;
		self.selectedSupervisorLabel.text = self.observation.supervisor.fullName;
	}
    
    if (self.observation.shiftId > 0) {
        for (Shift *s in self.shiftList) {
            if (s.shiftId == self.observation.shiftId) {
                self.selectedShift.description.text = s.shiftDescription;
                self.selectedShift.descriptionId = s.shiftId;
                self.selectedShiftLabel.text = s.shiftDescription;
                break;
            }
        }
    }
    
	[self.galleryViewEnabled setAlpha:0.0];
	[self.activityIndicator stopAnimating];
	[self.loadingPicturesLabel.layer removeAnimationForKey:@"LoadingPicturesAnimation"];
	[self.loadingPicturesLabel setAlpha:0.0];
	[self.activityIndicator setAlpha:0.0];
}

- (void)viewDidUnload 
{
    [self setAuditeeTableView:nil];
    [self setSupervisorsTableView:nil];
    [self setWorkCentersTableView:nil];
    [self setImagesTableView:nil];
    [self setShiftView:nil];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if ([tableView tag] == 0)
	{
		return _auditeeSearching ? [self.auditeeUsersCopy count] : [self.usersFacility count];
	} 
	else if ([tableView tag] ==  1)
	{
		return _workCenterSearching ? [self.workCentersCopy count] : [self.workCenters count];
	}
	else if ([tableView tag] ==  2)
	{
		return _supervisorSearching ? [self.supervisorUsersCopy count] : [self.usersFacility count];
	} 
	else if ([tableView tag] ==  3)
	{
		return [self.observation.images count];
	}
    else if(tableView.tag == 4)
    {
        return self.shiftList.count;
    }
	else
	{
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
	if ([tableView tag] == 3) 
	{
		static NSString *CellIdentifier = @"Cell";
		NSString *nibName = @"GalleryPhotoCellViewController";
		
		GalleryPhotoCellViewController *cell = (GalleryPhotoCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
		if (cell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
			for (id currentObject in topLevelObjects) 
			{
				if ([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (GalleryPhotoCellViewController *)currentObject;
					break;
				}
			}
		}
		IPAObservationAttachedFile *f = [self.observation.images objectAtIndex:indexPath.row];
		cell.image.image = f.fileData;
		cell.photoDescription.text = f.fileNotes;
		cell.attachedFile = f;
		cell.count = self.observation.images.count;
		cell.index = indexPath.row + 1;
		cell.fileDetailId = f.observationAttachedFileId;
        
		[cell initWithCaller:self];
		
		cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
		
		return cell;
	}
	else
	{
		static NSString *CellIdentifier = @"Cell";
		NSString *nibName = @"ObservationInfoViewController";
		
		ObservationInfoViewController *cell = (ObservationInfoViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
		if (cell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
			for (id currentObject in topLevelObjects) 
			{
				if ([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (ObservationInfoViewController *)currentObject;
					break;
				}
			}
		}
		
		if ([tableView tag] == 0) {
			if ((_auditeeSearching && [self.auditeeUsersCopy count] > 0) || !_auditeeSearching) {
				User *u = _auditeeSearching? [self.auditeeUsersCopy objectAtIndex:indexPath.row] : [self.usersFacility objectAtIndex:indexPath.row];
				cell.description.text = u.fullName;
				cell.descriptionId = u.userMasterId;
			}else{			
				cell.description.text = @"";
				cell.descriptionId = 0;
			}
		}
        else if ([tableView tag] == 4) {
            Shift *s = [self.shiftList objectAtIndex:indexPath.row];
            cell.description.text = s.shiftDescription;
            cell.descriptionId = s.shiftId;
        }
		else if ([tableView tag] == 1) {
			if ((_workCenterSearching && [self.workCentersCopy count] > 0) || !_workCenterSearching) {
				WorkCenter *f = _workCenterSearching ? [self.workCentersCopy objectAtIndex:indexPath.row] : [self.workCenters objectAtIndex:indexPath.row];
				cell.description.text = f.workCenterCodeDescription;
				cell.descriptionId = f.workCenterId;
			}else{			
				cell.description.text = @"";
				cell.descriptionId = 0;
			}
		}
		else  if ([tableView tag] == 2) {
			if ((_supervisorSearching && [self.supervisorUsersCopy count] > 0) || !_supervisorSearching) {
				User *u = _supervisorSearching ? [self.supervisorUsersCopy objectAtIndex:indexPath.row] : [self.usersFacility objectAtIndex:indexPath.row];
				cell.description.text = u.fullName;
				cell.descriptionId = u.userMasterId;
			}else{			
				cell.description.text = @"";
				cell.descriptionId = 0;
			}
		}
        
		
		return cell;
	}
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{   
	if ([tableView tag] == 0) {
		User *u = _auditeeSearching? [self.auditeeUsersCopy objectAtIndex:indexPath.row] : [self.usersFacility objectAtIndex:indexPath.row];
		self.selectedAuditee.description.text = u.fullName;
		self.selectedAuditee.descriptionId = u.userMasterId;
		self.selectedAuditeeLabel.text = u.fullName;
		
		self.observation.auditee = u;
		
		[self SelectAWCSAction:auditeeButton];
	}
	else if ([tableView tag] == 1) {
		WorkCenter *f = _workCenterSearching ? [self.workCentersCopy objectAtIndex:indexPath.row] : [self.workCenters objectAtIndex:indexPath.row];
		self.selectedWorkCenter.description.text = f.description;
		self.selectedWorkCenter.descriptionId = f.workCenterId;
		self.selectedWorkCenterLabel.text = f.description;
		
		self.observation.workCenterId = f.workCenterId;
		
		[self SelectAWCSAction:workCenterButton];
        if (copySelectedWorkCenterSwitch.isOn) {
            [self.caller copySelectedWorkCenterItem:f.workCenterId];
        }
	}
	else if ([tableView tag] == 2) {
		User *u = _supervisorSearching ? [self.supervisorUsersCopy objectAtIndex:indexPath.row] : [self.usersFacility objectAtIndex:indexPath.row];
		self.selectedSupervisor.description.text = u.fullName;
		self.selectedSupervisor.descriptionId = u.userMasterId;
		self.selectedSupervisorLabel.text = u.fullName;
		
		self.observation.supervisor = u;
		
		[self SelectAWCSAction:supervisorButton];
        if (copySelectedSupervisorSwitch.isOn) {
            [self.caller copySelectedUserItem:u];
        }
	}
    else if([tableView tag] == 4)
    {
        Shift *s = [self.shiftList objectAtIndex:indexPath.row];
        
        self.observation.shiftId = s.shiftId;
        
        self.selectedShift.description.text = s.shiftDescription;
        self.selectedShift.descriptionId = s.shiftId;
        self.selectedShiftLabel.text = s.shiftDescription;
        [self SelectAWCSAction:shiftButton];
        if (copySelectedShiftSwitch.isOn) {
            [self.caller copySelectedShiftItem:s.shiftId];
        }
        
    }
	[self.caller textFieldDidEndEditing:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView tag] == 0 || [tableView tag] == 1 || [tableView tag] == 2)
	{
		return 19.0;
	}else if ([tableView tag] == 3)
	{
		return 361.0;
	}
    else if ([tableView tag] == 4 || [tableView tag] == 5)
    {
        return 21;
    }
	return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{   
	if ([tableView tag] == 3)
	{
		self.galleryView.transform = CGAffineTransformMakeRotation(-1 * M_PI / 2);
	}
}


#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[self.caller textFieldDidBeginEditing:searchBar];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[self.caller textFieldDidEndEditing:searchBar];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{	
	if ([theSearchBar tag] == 0) {
		
		[self.auditeeUsersCopy removeAllObjects];
		
		_auditeeSearching = [searchText length] > 0;
		
		if ([searchText length] > 0) 
		{
			[self searchAuditeeTableView];
		}
		
		self.selectedAuditee.descriptionId = 0;
		self.selectedAuditeeLabel.text = @"{Auditee Name}";
		self.observation.auditee = nil;
		[self.auditeeTableView reloadData];
		
	} else if ([theSearchBar tag] == 1) {
		
		[self.workCentersCopy removeAllObjects];
		
		_workCenterSearching = [searchText length] > 0;
		
		if ([searchText length] > 0) 
		{
			[self searchWorkCenterTableView];
		}
		
		self.selectedWorkCenter.descriptionId = 0;
		self.selectedWorkCenterLabel.text = @"{Work Center Name}";
		self.observation.workCenterId = 0;
		[self.workCentersTableView reloadData];
		
	} else{
		
		[self.supervisorUsersCopy removeAllObjects];
		
		_supervisorSearching = [searchText length] > 0;
		
		if ([searchText length] > 0) 
		{
			[self searchSupervisorTableView];
		}
		
		self.selectedSupervisor.descriptionId = 0;
		self.selectedSupervisorLabel.text = @"{Supervisor Name}";
		self.observation.supervisor = nil;
		[self.supervisorsTableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	if ([searchBar tag] == 0) {
		self.auditeeSearchBar.text = @"";
		[self.auditeeSearchBar resignFirstResponder];
		
		_auditeeSearching = NO;
		
		[self.auditeeTableView reloadData];
		
		
	} else if ([searchBar tag] == 1) {
		self.workCenterSearchBar.text = @"";
		[self.workCenterSearchBar resignFirstResponder];
		
		_workCenterSearching = NO;
		
		[self.workCentersTableView reloadData];
		

		
	} else{
		self.supervisorSearchBar.text = @"";
		[self.supervisorSearchBar resignFirstResponder];
		
		_supervisorSearching = NO;
		
		[self.supervisorsTableView reloadData];
		

	}	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
	searchBar.text = @"";
}

- (void)searchAuditeeTableView 
{	
	NSString *searchText = self.auditeeSearchBar.text;
	
	for (id f in self.usersFacility)
	{
		if (self.auditeeSearchBar.selectedScopeButtonIndex == 0) {
			
			NSRange titleResultsRange = [[f fullName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (titleResultsRange.length > 0)
			{
				[self.auditeeUsersCopy addObject:f];
			}
		}
		else
		{
			NSRange titleResultsRange = [[NSString stringWithFormat:@"%d",(int)[f userMasterId]] rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (titleResultsRange.length > 0)
			{
				[self.auditeeUsersCopy addObject:f];
			}
		}
	}
}

- (void)searchWorkCenterTableView 
{	
	NSString *searchText = self.workCenterSearchBar.text;
	
	for (id f in self.workCenters)
	{
		if (self.workCenterSearchBar.selectedScopeButtonIndex == 0) {
			
			NSRange titleResultsRange = [[f description] rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (titleResultsRange.length > 0)
			{
				[self.workCentersCopy addObject:f];
			}
		}
		else
		{
			NSRange titleResultsRange = [[f workCenterCode] rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (titleResultsRange.length > 0)
			{
				[self.workCentersCopy addObject:f];
			}	
		}
	}
}

- (void)searchSupervisorTableView
{	
	NSString *searchText = self.supervisorSearchBar.text;
	
	for (id f in self.usersFacility)
	{
		if (self.supervisorSearchBar.selectedScopeButtonIndex == 0) {
			
			NSRange titleResultsRange = [[f fullName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (titleResultsRange.length > 0)
			{
				[self.supervisorUsersCopy addObject:f];
			}
		}
		else
		{
			NSRange titleResultsRange = [[NSString stringWithFormat:@"%d",(int)[f userMasterId]] rangeOfString:searchText options:NSCaseInsensitiveSearch];
			if (titleResultsRange.length > 0)
			{
				[self.supervisorUsersCopy addObject:f];
			}
		}
	}
}


#pragma mark -
#pragma mark FailOptionsViewControllerDelegate

- (void)failOptionsDone:(id)context
{
	if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
	{
		[self.failOptionsPopover dismissPopoverAnimated:YES];
	}
	else
	{
		[[self.failOptionsView view]removeFromSuperview];
	}
	
	NSString *failOption = @"";
	
	if ([self.failOptionsView.machine isSelected]) 
	{
		failOption = @"Machine";
	}else if([self.failOptionsView.man isSelected])
	{
		failOption = @"Man";
	}else if([self.failOptionsView.material isSelected])
	{
		failOption = @"Material";
	}else if([self.failOptionsView.environmental isSelected])
	{
		failOption = @"Environmental";
	}else if([self.failOptionsView.method isSelected])
	{
		failOption = @"Method";
	}
	
	if ([failOption length] == 0) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Fail option is required"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		
		[alert show];
	}
	else{
		if ([self ValidateObservationInfo:nil]) {
			
			self.loader = [[ActivityAlertView alloc] initWithMessage:@"Saving Observation..."];
			[self.loader show];
			
			User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
			
			NSString *address;
			
			if (self.observation.observationId == 0) {
				NSString *result = [self CanSave];
				if ([result isEqualToString:@"\"VALID\""]) {
					//SAVE
					address = [NSString stringWithFormat:@"%@InProcessAuditObservationSave?User=%d&occ=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.pendingOccurrence.occurrenceId,(int)self.selectedAuditee.descriptionId,(int)self.selectedWorkCenter.descriptionId,(int)self.selectedSupervisor.descriptionId,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"FAIL",failOption,@"", (int)self.selectedShift.descriptionId];
				}else
				{
					//ALert		
					UIAlertView *alert;
					
					if ([result isEqualToString:@"\"PASTDUECOMMENT\""]) 
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
						alert.tag = 2;
					}
					else
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					}
					
					[self.loader close];
					[alert show];
					return;
				}
			}
			else
			{	
				NSString *result = [self CanSave];
				if ([result isEqualToString:@"\"VALID\""]) {
					address = [NSString stringWithFormat:@"%@InProcessAuditObservationUpdate?User=%d&obsId=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.observation.observationId,(int)self.selectedAuditee.descriptionId,(int)self.selectedWorkCenter.descriptionId,(int)self.selectedSupervisor.descriptionId,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"FAIL",failOption,@"", (int)self.selectedShift.descriptionId];
				}else
				{
					//ALert
					UIAlertView *alert;
					
					if ([result isEqualToString:@"\"PASTDUECOMMENT\""]) 
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
						alert.tag = 2;
					}
					else
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					}
					
					[self.loader close];
					[alert show];
					return;
				}
			}
			address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
			NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
			NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
			
			if([json_string integerValue] < 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Observation wasn't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				
				[self.loader close];
				[alert show];
			}
			else
			{
				self.observation.observationId = self.observation.observationId == 0? [json_string integerValue] : self.observation.observationId;
				if ([self savePictures]) {
					[self.enableTopView setAlpha:0.4];
					[self.enableBottomView setAlpha:0.4];
					[self.editButton setAlpha:1.0];
					self.statusLabel.text = @"FAIL";
					[self.statusView setAlpha:0.8];
					
					[self.caller occurrenceCellSaved:self.currentObservationIndex];
				}
			}
			[self.loader close];
		}	
	}
}

- (void)failOptionsCancel:(id)context
{
	if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
	{
		[self.failOptionsPopover dismissPopoverAnimated:YES];
	}
	else
	{
		[[self.failOptionsView view]removeFromSuperview];
	}
	// register for keyboard notifications
	
}


#pragma mark -
#pragma mark NotCompleteNotesViewControllerDelegate

- (void)notCompleteNotesDone:(id)context
{
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        [self.notCompleteNotesPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [[self.notCompleteNotesView view]removeFromSuperview];
    }
	
	NSString *note = [self.notCompleteNotesView.noteTextView text];
	if ([note length] == 0) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Incomplete note is required"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		
		[alert show];
	}
	else{
		if ([self ValidateObservationInfoNotComplete]) {
			
			self.loader = [[ActivityAlertView alloc] initWithMessage:@"Saving Observation..."];
			[self.loader show];
			
			User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
			
			NSString *address;
			
			if (self.pendingOccurrence.observationValue.length > 0) {
				NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
				NSNumber* number = [numberFormatter numberFromString:self.enteredObservationValue.text];
				if (!number) {
					self.enteredObservationValue.text = @"";
				}
			}
			
			if (self.observation.observationId == 0) {
				NSString *result = [self CanSave];
				if ([result isEqualToString:@"\"VALID\""]) {
					//SAVE
					NSInteger auditeeValue = self.selectedAuditee.descriptionId;
					NSInteger workCenterValue = self.selectedWorkCenter.descriptionId;
					NSInteger supervisorValue = self.selectedSupervisor.descriptionId;
					
					if (self.observation.auditee.userMasterId < 1) {
						auditeeValue = 0;
					}
					
					if (self.observation.workCenterId < 1) {
						workCenterValue = 0;
					}
					
					if (self.observation.supervisor.userMasterId < 1) {
						supervisorValue = 0;
					}
					
					address = [NSString stringWithFormat:@"%@InProcessAuditObservationSave?User=%d&occ=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.pendingOccurrence.occurrenceId,(int)auditeeValue,(int)workCenterValue,(int)supervisorValue,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"INCOMPLETE",@"",note, (int)self.selectedShift.descriptionId];
				}else
				{
					//ALert		
					UIAlertView *alert;
					
					if ([result isEqualToString:@"\"PASTDUECOMMENT\""]) 
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
						alert.tag = 2;
					}
					else
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					}
					
					[self.loader close];
					[alert show];
					return;
				}
			}
			else
			{
				NSString *result = [self CanSave];
				if ([result isEqualToString:@"\"VALID\""]) {
					NSInteger auditeeValue = self.selectedAuditee.descriptionId;
					NSInteger workCenterValue = self.selectedWorkCenter.descriptionId;
					NSInteger supervisorValue = self.selectedSupervisor.descriptionId;
					
					if (self.observation.auditee.userMasterId < 1) {
						auditeeValue = 0;
					}
					
					if (self.observation.workCenterId < 1) {
						workCenterValue = 0;
					}
					
					if (self.observation.supervisor.userMasterId < 1) {
						supervisorValue = 0;
					}
					
					address = [NSString stringWithFormat:@"%@InProcessAuditObservationUpdate?User=%d&obsId=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.observation.observationId,(int)auditeeValue,(int)workCenterValue,(int)supervisorValue,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"INCOMPLETE",@"",note, (int)self.selectedShift.descriptionId];
				}else
				{
					//ALert		
					UIAlertView *alert;
					
					if ([result isEqualToString:@"\"PASTDUECOMMENT\""]) 
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence requires a past due comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
						alert.tag = 2;
					}
					else
					{
						alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:[NSString stringWithFormat:@"%@", result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					}
					
					[self.loader close];
					[alert show];
					return;
				}
			}
			address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
			NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
			NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
			
			if([json_string integerValue] < 1)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Observation wasn't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				
				[self.loader close];
				[alert show];
			}
			else
			{
				self.observation.observationId = self.observation.observationId == 0? [json_string integerValue] : self.observation.observationId;
				if ([self savePictures]) {
					[self.enableTopView setAlpha:0.4];
					[self.enableBottomView setAlpha:0.4];
					[self.editButton setAlpha:1.0];
					self.statusLabel.text = @"INCOMPLETE";
					[self.statusView setAlpha:0.8];
					
					[self.caller occurrenceCellSaved:self.currentObservationIndex];
				}
			}
			[self.loader close];
		}
	}
}

- (void)notCompleteNotesCancel:(id)context
{
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        [self.notCompleteNotesPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [[self.notCompleteNotesView view]removeFromSuperview];
    }
    // register for keyboard notifications
	
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex 
{
	//TAG = 1: CANCELING OBSERVATIONS
	if (buttonIndex == 1 && alertView.tag == 1)
	{
		//CANCEL
		self.loader = [[ActivityAlertView alloc] initWithMessage:@"Canceling Observations..."];
		[self.loader show];
		
		User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
		
        
        NSString *address = [NSString stringWithFormat:@"%@InProcessAuditObservationUpdate?User=%d&obsId=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId,(int)self.observation.observationId,(int)self.selectedAuditee.descriptionId,(int)self.selectedWorkCenter.descriptionId,(int)self.selectedSupervisor.descriptionId,self.enteredObservationValue.text,self.enteredGeneralNotes.text,@"CANCELED",@"",@"", (int)self.selectedShift.descriptionId];
        
        address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		
		if([json_string integerValue] < 1)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Observation wasn't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[self.loader close];
			[alert show];
		}
		else
		{
			self.observation.observationId = self.observation.observationId == 0? [json_string integerValue] : self.observation.observationId;
			if ([self savePictures]) {
				[self.enableTopView setAlpha:0.4];
				[self.enableBottomView setAlpha:0.4];
				[self.editButton setAlpha:1.0];
				self.statusLabel.text = @"CANCELED";
				[self.statusView setAlpha:0.8];
				
				[self.caller occurrenceCellSaved:self.currentObservationIndex];
			}
		}
		[self.loader close];
        
        /*
		NSString *address = [NSString stringWithFormat:@"%@InProcessAuditObservationCancel?User=%d&occ=%d&aud=%d&wc=%d&sup=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], u.userMasterId,self.pendingOccurrence.occurrenceId,self.selectedAuditee.descriptionId,self.selectedWorkCenter.descriptionId,self.selectedSupervisor.descriptionId];
		
		address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
		[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		
		[self.caller occurrenceCellCancelObservations:nil];
//		[self.caller occurrenceCellSaved:nil];
		[self.loader close];
         */
	}
	
	//TAG = 2: SHOW ADD PAST DUE COMMENT
	if (alertView.tag == 2)
	{
		[self.caller openAddPastDueDateComment:nil];
	}
    

    if (alertView.tag == 3) { 
        
        if (buttonIndex == 0) { // Create QP
            [self.caller occurrenceCellAddIQP:self.observation];
        } else { // Continue mark Observation as Fail
            self.failOptionsView = [[FailOptionsViewController alloc] initWithCaller:self title:@"New Part" andContext:nil];
            
            if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
                self.failOptionsPopover =[[UIPopoverController alloc]initWithContentViewController:self.failOptionsView];
                
                [self.failOptionsPopover presentPopoverFromRect: CGRectMake(185, 657, 100, 100)
                                                         inView:self
                                       permittedArrowDirections:UIPopoverArrowDirectionDown 
                                                       animated:YES];
            } else
            {
                [self addSubview:[self.failOptionsView view]];
                [[self.failOptionsView view] makeShadow];
            }
        }
    }
}

#pragma mark -
#pragma mark Camera Implementation


- (IBAction)takePicture:(id)sender
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
	}else{
		[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	
	[imagePicker setDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self];
	
	_imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];

	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	

	if (UIInterfaceOrientationIsPortrait(orientation)) {
		[_imagePickerPopover presentPopoverFromRect:CGRectMake(665, 395, 100, 100) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else
	{
		[_imagePickerPopover presentPopoverFromRect:CGRectMake(625, 395, 100, 100) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.loader = [[ActivityAlertView alloc] initWithMessage:@"Loading Pictures..."];
	[self.loader show];
	
	NSMutableArray *imagesCopy = [NSMutableArray arrayWithArray:self.observation.images];
	
	[self.observation.images removeAllObjects];
	self.observation.images = [NSMutableArray arrayWithCapacity:[imagesCopy count] + 1];
	
	[self.observation.images addObjectsFromArray: imagesCopy];
	
	IPAObservationAttachedFile *tempObsA = [[IPAObservationAttachedFile alloc] init];
	
	tempObsA.observationId = self.observation.observationId;
	tempObsA.observationAttachedFileId = 0;
	tempObsA.fileType = @"JPEG";
	
	
	
//	tempObsA.fileData = [info objectForKey:UIImagePickerControllerOriginalImage];

	
	
	UIImage *tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	tempObsA.fileData = [tempImage fixOrientation];

	
	
	
	tempObsA.fileNotes = [NSString stringWithFormat: @"Picture %d", (int)self.observation.images.count + 1];
	
	[self.observation.images addObject:tempObsA];

	[self.backgroundImage setAlpha:0.0];
	
	[self.imagesTableView reloadData];
	
	[self.loader close];
	[_imagePickerPopover dismissPopoverAnimated:YES];
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
//	NSData *imageData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
//
//	NSString *str = [imageData base64Encoding];
//	NSData *newImageData = [NSData dataWithBase64EncodedString:str];
//
//	tempObsA.fileData = [UIImage imageWithData:newImageData];
//
//	NSData *imageData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);	
//	
//	NSUInteger len = [imageData length];
//	char *byteData = (char *)malloc(len);
//	memcpy(byteData, [imageData bytes], len);
//	
//	NSData *newImageData = [NSData dataWithBytes:byteData length:len - 1];
//	tempObsA.fileData = [UIImage imageWithData:newImageData];
//
//	tempObsA.fileNotes = [NSString stringWithFormat: @"Picture %d", self.images.count + 1];
//	
//	[self.images addObject:tempObsA];
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
}

-(BOOL) savePictures
{	
	User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
	if (self.observation.observationId > 0) {
		for (IPAObservationAttachedFile *image in self.observation.images) {
			
			if (image.observationAttachedFileId == 0) {
				
				NSData *imageData = UIImageJPEGRepresentation(image.fileData, 0.0);
				
				NSString *postLength = [NSString stringWithFormat:@"%d", (int)[imageData length]];
				
				NSString *fullName = [NSString stringWithFormat:@"%@.%@", image.fileNotes, image.fileType];
				
				NSString *urlString = [NSString stringWithFormat:@"%@fileName/%@/recordId/%d/fileApplicationName/AuditSuiteObservationImages/userId/%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] fileManagementServerPath], fullName, (int)self.observation.observationId, (int)u.userMasterId];
				
				urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				
				NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
				[request setURL:[NSURL URLWithString:urlString]];
				[request setHTTPMethod:@"POST"];
				[request setValue:postLength forHTTPHeaderField:@"Content-length"];
				[request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-type"];
				[request setHTTPBody:imageData];
				
				NSError *error = nil;
				
				// connect to the web
				NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
				NSString *json_string = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];	
				
				if (!json_string) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Image wasn't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					[alert show];
					[_imagePickerPopover dismissPopoverAnimated:YES];
					
					return NO;
				}
			}
			else
			{
				//TODO: INVOKE UPDATE IMAGE METHOD
			}
			
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Images weren't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		return NO;
	}
	
	return YES;
}


#pragma mark -
#pragma mark KeyBoard Animation And UITextFieldDelegate

-(IBAction)textFieldDidBeginEditing:(id)sender
{
	[self.caller textFieldDidBeginEditing:sender];
}

-(IBAction)textFieldDidEndEditing:(id)sender
{
	UITextField * textField = (UITextField *) sender;
	self.observation.observationValue = textField.text;
	[self.caller textFieldDidEndEditing:sender];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{ 
	if (textField.tag == 1) {

		NSCharacterSet *controlSet = [NSCharacterSet controlCharacterSet];
		if (![string stringByTrimmingCharactersInSet:controlSet].length > 0) {
			return YES;
		}
		
		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:DECIMALCHARSET] invertedSet];
		return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
	}
	return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self.caller textFieldDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	self.observation.generalNotes = textView.text;
	[self.caller textFieldDidEndEditing:textView];
}


#pragma mark -
#pragma mark GalleryPhotoCellViewControllerDelegate

-(void) photoDeleted:(id) context
{
	GalleryPhotoCellViewController *cell = (GalleryPhotoCellViewController *) context;
	
	//TODO: PENDING INVOKE DELETE IMAGE METHOD IF IMAGEATTACHEDID > 0
	
	[self.observation.images removeObjectAtIndex:cell.index - 1];
	
	if (self.observation.images.count == 0) {
		[self.backgroundImage setAlpha:1.0];
	}
	
	[self.imagesTableView reloadData];
}

-(void) photoChanged:(id)context
{
	GalleryPhotoCellViewController *cell = (GalleryPhotoCellViewController *) context;
	
	IPAObservationAttachedFile *f = [self.observation.images objectAtIndex:cell.index - 1];
	
	[f setFileNotes:cell.photoDescription.text];
    
    [self updateFileDetailDescription:cell.fileDetailId and:cell.photoDescription.text];
}

- (void) updateFileDetailDescription : (NSInteger ) fileDetialId and: (NSString *) fileDetailDescription
{
    NSString *address = [NSString stringWithFormat:@"%@UpdateFileDescription/fileDetailId/%d/fileDescription/%@", [(AppDelegate *) [[UIApplication sharedApplication] delegate] fileManagementServerPath], (int)fileDetialId, fileDetailDescription];
    
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

-(void)firstPhoto:(id)context
{
	NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.imagesTableView scrollToRowAtIndexPath:firstIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)previousPhoto:(id)context
{
	GalleryPhotoCellViewController *cell = (GalleryPhotoCellViewController *) context;
	
	if (cell.index - 2 >= 0) {
		NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:cell.index - 2 inSection:0];
		[self.imagesTableView scrollToRowAtIndexPath:previousIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
}

-(void)nextPhoto:(id)context
{
	GalleryPhotoCellViewController *cell = (GalleryPhotoCellViewController *) context;
	
	if (cell.index <= self.observation.images.count - 1) {
		NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:cell.index inSection:0];
		[self.imagesTableView scrollToRowAtIndexPath:previousIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
}

-(void)lastPhoto:(id)context
{
	NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.observation.images.count - 1 inSection:0];
	[self.imagesTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)nameDidBeginEditing:(id)context
{
	[self.caller textFieldDidBeginEditing:context];
}

-(void)nameDidEndEditing:(id)context
{
	[self.caller textFieldDidEndEditing:context];
}



@end
