//
//  OccurrenceViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OccurrenceViewController.h"
#import "IPAObservation.h"
#import "AppDelegate.h"
#import "User.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "InternalQPEntryViewController.h"

@implementation OccurrenceViewController

@synthesize loader = _loader;
@synthesize pendingOccurrence = _pendingOccurrence;
@synthesize observations = _observations;
@synthesize tableView = _tableView;
@synthesize headerView = _headerView;
@synthesize dueDate = _dueDate;
@synthesize originalDueDate = _originalDueDate;
@synthesize area = _area;
@synthesize type = _type;
@synthesize focus = _focus;
@synthesize instruction = _instruction;
@synthesize obs = _obs;
@synthesize frequency = _frequency;
@synthesize count = _count;
@synthesize currentVersionLabel = _currentVersionLabel;
@synthesize currentUserLabel = _currentUserLabel;
@synthesize addDueDateComment = _addDueDateComment;
@synthesize leadAuditor = _leadAuditor;
@synthesize dueDateCommentView = _dueDateCommentView;
@synthesize dueDateCommentPopover = _dueDateCommentPopover;
@synthesize active = _active;
@synthesize firstPendingObservation = _firstPendingObservation;
@synthesize auditId = _auditId;
@synthesize index = _index;

#pragma mark -
#pragma mark Initialization

- (id)initWithPendingOccurrence:(IPAPendingOccurrence *)thePendingOcc
{
	NSString *nibName = @"OccurrenceViewController";
	
	self = [super initWithNibName:nibName bundle:nil];
	
	self.pendingOccurrence = thePendingOcc;
	
	return self;
}

- (IBAction)DueDateCommentAction:(id)sender
{
    self.dueDateCommentView = [[DueDateCommentViewController alloc] initWithCaller:self title:@"New Part" andContext:nil];
    
	[self.addDueDateComment.imageView.layer removeAnimationForKey:@"alertAnimation"];
	
	self.dueDateCommentPopover =[[UIPopoverController alloc]initWithContentViewController:self.dueDateCommentView];
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		[self.dueDateCommentPopover presentPopoverFromRect: CGRectMake(590, 925, 100, 100)
													inView:self.view
								  permittedArrowDirections:UIPopoverArrowDirectionDown 
												  animated:YES];
	}
	else
	{
		[self.dueDateCommentPopover presentPopoverFromRect: CGRectMake(840, 665, 100, 100)
													inView:self.view
								  permittedArrowDirections:UIPopoverArrowDirectionDown 
												  animated:YES];
	}
	
	[[self.dueDateCommentView noteTextView] becomeFirstResponder];
}

- (void)openAddPastDueDateComment:(id)context
{
    self.dueDateCommentView = [[DueDateCommentViewController alloc] initWithCaller:self title:@"New Part" andContext:nil];
    
	[self.addDueDateComment.imageView.layer removeAnimationForKey:@"alertAnimation"];
	
	self.dueDateCommentPopover =[[UIPopoverController alloc]initWithContentViewController:self.dueDateCommentView];
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		[self.dueDateCommentPopover presentPopoverFromRect: CGRectMake(590, 925, 100, 100)
													inView:self.view
								  permittedArrowDirections:UIPopoverArrowDirectionDown 
												  animated:YES];
	}
	else
	{
		[self.dueDateCommentPopover presentPopoverFromRect: CGRectMake(840, 665, 100, 100)
													inView:self.view
								  permittedArrowDirections:UIPopoverArrowDirectionDown 
												  animated:YES];
	}
	
	[[self.dueDateCommentView noteTextView] becomeFirstResponder];
}

//- (void)becomeActive:(NSNotification *)notification 
//{	
//	if (![self isEqual: [[(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController] visibleViewController]]) 
//	{
//		return;
//	}
//}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Observations"];
    
    self.loader = [[ActivityAlertView alloc] initWithMessage:@"Loading Observations..."];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(becomeActive:)
//												 name:UIApplicationWillEnterForegroundNotification
//											   object:nil];
    
    [self.headerView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:10.0f MaskBounds:YES];
	[((UIScrollView *) self.view) setContentSize:CGSizeMake(768.0, 96.0)];
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation]; 
	
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		self.tableView.pagingEnabled = YES;
	}
	else
	{
		self.tableView.pagingEnabled = NO;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	if (!self.observations || [self.observations count] == 0)
	{
		[self.loader show];
		
        [NSThread detachNewThreadSelector:@selector(loadData)
								 toTarget:self
							   withObject:nil];
        self.instruction.text = [self.pendingOccurrence instruction];
	}
	
	currentUser = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
	self.currentUserLabel.text = [NSString stringWithFormat:@"Current User: %@", currentUser.fullName];
	self.currentVersionLabel.text = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentVersion];
    
    [self.tableView reloadData]; // Reload QP number.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (animatedDistance > 0) {
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y += animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
		
		animatedDistance = 0;
	}
	
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.tableView.pagingEnabled = YES;
	}
	else
	{
		self.tableView.pagingEnabled = NO;
	}	
}

- (void) viewWillDisappear:(BOOL)animated
{
	[self SaveAndExit];
}

- (void) SaveAndExit
{
	@try {
		if (!useSaveAndExit) {
			useSaveAndExit = YES;
			return;
		}
		
		self.loader = [[ActivityAlertView alloc] initWithMessage:@"Please Wait..."];
		[self.loader show];
		
		for (OccurrenceCellViewController *visibleCell in [self.tableView visibleCells]) {
			[visibleCell.enteredGeneralNotes endEditing:YES];
			[visibleCell.enteredObservationValue endEditing:YES];
		}
		
		for (int i = 0; i < self.observations.count; i++) {
			
            
            
			IPAObservation *observationTemp = [self.observations objectAtIndex:i];
			
			BOOL hasObservationsChanges = NO;
			BOOL hasImagesChanges = NO;
			
			if (((observationTemp.auditee.userMasterId > 0 
				|| observationTemp.workCenterId > 0 
				|| observationTemp.supervisor.userMasterId > 0 
				|| [observationTemp.generalNotes length] > 0 
				|| [observationTemp.observationValue length] > 0)
				&& observationTemp.observationId == 0) || observationTemp.observationId > 0) 
			{		
				hasObservationsChanges = YES;
			}
			
			//TODO: Pending validate if there are pictures pending to save
			hasImagesChanges = observationTemp.images.count > 0;
			
			
			NSString *statusObservation = @"PENDING";
			if (![observationTemp.status isEqualToString:@""] && ![observationTemp.status isEqualToString:@"PENDING"]) {		
				statusObservation = observationTemp.status;
			}
			
			if (hasObservationsChanges || hasImagesChanges) {
				
				NSString *address;
				
				NSInteger auditeeValue = observationTemp.auditee.userMasterId;
				NSInteger workCenterValue = observationTemp.workCenterId;
				NSInteger supervisorValue = observationTemp.supervisor.userMasterId;
                
				if (observationTemp.auditee.userMasterId < 1) {
					auditeeValue = 0;
				}
				
				if (observationTemp.workCenterId < 1) {
					workCenterValue = 0;
				}
				
				if (observationTemp.supervisor.userMasterId < 1) {
					supervisorValue = 0;
				}
				
				NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
				NSNumber* number = [numberFormatter numberFromString:observationTemp.observationValue];
				if (!number) {
					observationTemp.observationValue = @"";
				}
				if (observationTemp.observationId == 0) {
					
					address = [NSString stringWithFormat:@"%@InProcessAuditObservationSave?User=%d&occ=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)currentUser.userMasterId,(int)self.pendingOccurrence.occurrenceId,(int)auditeeValue,(int)workCenterValue,(int)supervisorValue,observationTemp.observationValue,observationTemp.generalNotes,statusObservation,observationTemp.failType,observationTemp.notCompleteNotes, (int)observationTemp.shiftId];
				}
				else
				{
					address = [NSString stringWithFormat:@"%@InProcessAuditObservationUpdate?User=%d&obsId=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)currentUser.userMasterId,(int)observationTemp.observationId,(int)auditeeValue,(int)workCenterValue,(int)supervisorValue,observationTemp.observationValue,observationTemp.generalNotes,statusObservation,observationTemp.failType,observationTemp.notCompleteNotes, (int)observationTemp.shiftId];
				}
                
				address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
				NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
				NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
				NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
				
				if([json_string integerValue] > 0)
				{
					observationTemp.observationId = observationTemp.observationId == 0? [json_string integerValue] : observationTemp.observationId;

					for (IPAObservationAttachedFile *image in observationTemp.images) {
						
						if (image.observationAttachedFileId == 0) {
							NSData *imageData = UIImageJPEGRepresentation(image.fileData, 0.0);
							
							NSString *postLength = [NSString stringWithFormat:@"%d", (int)[imageData length]];
							
							NSString *fullName = [NSString stringWithFormat:@"%@.%@", image.fileNotes, image.fileType];
							
							NSString *urlString = [NSString stringWithFormat:@"%@fileName/%@/recordId/%d/fileApplicationName/AuditSuiteObservationImages/userId/%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] fileManagementServerPath], fullName, (int)observationTemp.observationId, (int)currentUser.userMasterId];
                            
							urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
							
							NSMutableURLRequest *requestImage = [[NSMutableURLRequest alloc] init];
							[requestImage setURL:[NSURL URLWithString:urlString]];
							[requestImage setHTTPMethod:@"POST"];
							[requestImage setValue:postLength forHTTPHeaderField:@"Content-length"];
							[requestImage addValue:@"image/jpeg" forHTTPHeaderField:@"Content-type"];
							[requestImage setHTTPBody:imageData];
							
							// connect to the web
							[NSURLConnection sendSynchronousRequest:requestImage returningResponse:nil error:nil];
						}
						else
						{
							//TODO: INVOKE UPDATE IMAGE METHOD
						}
					}
				}
			}
		}
		
		[self.loader close];
	}
	@catch (NSException *exception) {
		//do nothing
	}
	
}

#pragma mark -
#pragma mark Threading Messages

- (void)loadData
{
	if (self.pendingOccurrence) 
	{
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyyMMdd"];
		
		NSDate *today = [NSDate date];
		
		self.area.text = [[self.pendingOccurrence area] description];
		self.type.text = [[self.pendingOccurrence auditType] description];
		self.focus.text = [[self.pendingOccurrence focus] description];
		self.frequency.text = [[self.pendingOccurrence frequency] description];
		self.obs.text = [NSString stringWithFormat:@"%d", (int)[self.pendingOccurrence numberOfObservations]];
		self.dueDate.text = [self.pendingOccurrence occurrenceDateStr];
		self.leadAuditor.text = [[self.pendingOccurrence leadAuditor] fullName];
		self.originalDueDate = [self.pendingOccurrence occurrenceDate];
		self.count = [NSString stringWithFormat:@"%d", (int)[self.pendingOccurrence occurrenceCount]];
		self.active = [self.pendingOccurrence active];
		self.auditId.text = [NSString stringWithFormat:@"%d", (int)self.pendingOccurrence.seriesId];
        
		[self.addDueDateComment setAlpha: 0.0];
		
		NSComparisonResult result = [[df stringFromDate: today] compare: [df stringFromDate: [self.pendingOccurrence occurrenceDate]]]; // comparing two 
		
		if(result==NSOrderedDescending && [[self.pendingOccurrence pastDueComment] isEqualToString:@""]){
			//newDate is less
			self.addDueDateComment.alpha = 1.0;
			
			CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			[pulseAnimation setDuration: 0.5];
			[pulseAnimation setToValue: [NSNumber numberWithFloat:0.14]];
			[pulseAnimation setAutoreverses: YES];
			[pulseAnimation setRepeatCount: FLT_MAX];
			[self.addDueDateComment.imageView.layer addAnimation:pulseAnimation forKey:@"alertAnimation"];
		}
		
		SBJSON *parser = [[SBJSON alloc] init];
		NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditObservationsByOccurrenceId?id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)self.pendingOccurrence.occurrenceId];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
		
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
		NSArray *obs = [parser objectWithString:json_string error:nil];
        [self.observations removeAllObjects];
		self.observations = [NSMutableArray arrayWithCapacity:[self.pendingOccurrence numberOfObservations]];
		
		NSInteger validCount = 0;
		NSInteger TotalCount = 0;
//		NSInteger failCount = 0;
        
		for(NSDictionary *f in obs)
		{
			
			IPAObservation *tmp = [IPAObservation iPAObservationWithDictionary:f];
			[self.observations addObject:tmp];
			if (![tmp.status isEqualToString:@"PENDING"]) {
				validCount++;
			}
			{
//				if (self.firstPendingObservation == nil) {
//					self.firstPendingObservation = [NSIndexPath indexPathForRow:TotalCount inSection:0 ];
//				}
			}
            
			TotalCount++;
            
//            if ([tmp.status isEqualToString:@"FAIL"]) {
//                failCount++;
//            }
		}
        
        self.firstPendingObservation = [NSIndexPath indexPathForRow:(self.index) inSection:0 ];
		
		if (validCount == self.pendingOccurrence.numberOfObservations) {
            
//            if (failCount > 0) {
//                UIAlertView *alterQP = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Do you wish to enter QP" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: @"NO", nil];
//                alterQP.tag = 2;
//                [alterQP show];
//                return;
//            }
            
			//The Occurrence has been completed
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence has been completed successfully."delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
			[alert setTag:1];
			[alert show];
			
			return;
		}
        
        /*
		if (self.firstPendingObservation == nil) 
		{
			if (self.observations.count == [self.pendingOccurrence numberOfObservations]) {
				self.firstPendingObservation = [NSIndexPath indexPathForRow:self.observations.count - 1 inSection:0];
			}
			else
			{
				self.firstPendingObservation = [NSIndexPath indexPathForRow:self.observations.count inSection:0];
			}
		}
		*/
        
		for (int i = (int)self.observations.count; i < (int)[self.pendingOccurrence numberOfObservations]; i++)
		{
			IPAObservation *tempObs = [[IPAObservation alloc] init];
			
			tempObs.observationId = 0;
			tempObs.occurrenceId = 0;
			tempObs.workCenterId = 0;
			tempObs.observationValue = @"";
			tempObs.generalNotes = @"";
			tempObs.failType = @"";
			tempObs.notCompleteNotes = @"";
			tempObs.status = @"";
            tempObs.shiftId = 0;

			[self.observations addObject:tempObs];
		}
		
		useSaveAndExit = YES;
	}
	
	[self performSelectorOnMainThread:@selector(finish) 
						   withObject:nil 
						waitUntilDone:NO];
}

- (void)finish
{
	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:self.firstPendingObservation atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self.loader close];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [self.observations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    static NSString *CellIdentifier = @"Cell";
    NSString *nibName = @"OccurrenceCellViewController";
    
    OccurrenceCellViewController *cell = (OccurrenceCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
		for (id currentObject in topLevelObjects) 
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (OccurrenceCellViewController *)currentObject;
				break;
			}
		}
    }
    
	[cell.headerView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:10.0f MaskBounds:YES];
	[cell.headerNotesView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:10.0f MaskBounds:YES];
	[cell.auditeeView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
	[cell.selectedAuditeeView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:15.0f MaskBounds:YES];
	[cell.workCenterView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
	[cell.selectedWorkCenterView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:15.0f MaskBounds:YES];
	[cell.supervisorView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
	[cell.selectedSupervisorView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:15.0f MaskBounds:YES];
    [cell.selectedShiftView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:15.0f MaskBounds:YES];
    [cell.shiftView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
	[cell.buttonView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:5.0f MaskBounds:YES];
	[cell.statusView configureViewWithBorderColor:[UIColor whiteColor] BorderWith:18.00 CornerRadius:10.0f MaskBounds:YES];
	[cell.galleryView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
    
//	[cell.addInternalQP configureViewWithBorderColor:[UIColor orangeColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
    [cell.addInternalQP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.addInternalQP.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.addInternalQP setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                          stretchableImageWithLeftCapWidth:8.0f
                                          topCapHeight:0.0f]
                                forState:UIControlStateNormal];
    cell.addInternalQP.titleLabel.shadowColor = [UIColor orangeColor];
    cell.addInternalQP.titleLabel.shadowOffset = CGSizeMake(0, -1);

    [cell.passButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.passButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.passButton setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                            stretchableImageWithLeftCapWidth:8.0f
                                            topCapHeight:0.0f]
                                  forState:UIControlStateNormal];
    cell.passButton.titleLabel.shadowColor = [UIColor orangeColor];
    cell.passButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [cell.failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.failButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.failButton setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                         stretchableImageWithLeftCapWidth:8.0f
                                         topCapHeight:0.0f]
                               forState:UIControlStateNormal];
    cell.failButton.titleLabel.shadowColor = [UIColor orangeColor];
    cell.failButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [cell.notCompleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.notCompleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.notCompleteButton setBackgroundImage:[[UIImage imageNamed:@"Orange_Button.png"]
                                         stretchableImageWithLeftCapWidth:8.0f
                                         topCapHeight:0.0f]
                               forState:UIControlStateNormal];
    cell.notCompleteButton.titleLabel.shadowColor = [UIColor orangeColor];
    cell.notCompleteButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    
	cell.index = [indexPath row];
    cell.occurrenceCount.text = [NSString stringWithFormat:@"%d/%d",(int)[indexPath row] + 1 , (int)[self.observations count]];
	cell.observation = [self.observations objectAtIndex:indexPath.row];
	[cell initWithLoadData:self.pendingOccurrence withCaller:self];
    cell.currentObservationIndex = (int)[indexPath row];
    return cell;
}



#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 774.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    	  
//	OccurrenceCellViewController *lastCell = (OccurrenceCellViewController *)[[tableView visibleCells] lastObject];
//	[lastCell.enteredGeneralNotes endEditing:YES];
//	[lastCell.enteredObservationValue endEditing:YES];
    
	for (OccurrenceCellViewController *visibleCell in [tableView visibleCells]) {
		[visibleCell.enteredGeneralNotes endEditing:YES];
		[visibleCell.enteredObservationValue endEditing:YES];
	}
	
	OccurrenceCellViewController *myCell = (OccurrenceCellViewController *)cell;
	
	if (!self.active) {
		[myCell.enableTopView setAlpha:0.4];
		[myCell.enableBottomView setAlpha:0.4];
	}
	else{
		if ([myCell.observation.status length] > 0) {
			
			if ([myCell.observation.status isEqualToString:@"PASS"]) {
				myCell.statusLabel.text = @"PASS";
				[myCell.enableTopView setAlpha:0.4];
				[myCell.enableBottomView setAlpha:0.4];
				[myCell.editButton setAlpha:1.0];
				[myCell.statusView setAlpha:0.8];
				myCell.statusView.transform = CGAffineTransformMakeRotation(-69.5);	
				
			}else if([myCell.observation.status isEqualToString:@"INCOMPLETE"]){
				myCell.statusLabel.text = @"INCOMPLETE";
				[myCell.enableTopView setAlpha:0.4];
				[myCell.enableBottomView setAlpha:0.4];
				[myCell.editButton setAlpha:1.0];
				[myCell.statusView setAlpha:0.8];
				myCell.statusView.transform = CGAffineTransformMakeRotation(-69.5);	
				
			}else if([myCell.observation.status isEqualToString:@"FAIL"]){
				myCell.statusLabel.text = @"FAIL";
				[myCell.enableTopView setAlpha:0.4];
				[myCell.enableBottomView setAlpha:0.4];
				[myCell.editButton setAlpha:1.0];
				[myCell.statusView setAlpha:0.8];
				myCell.statusView.transform = CGAffineTransformMakeRotation(-69.5);	
				
			}else if([myCell.observation.status isEqualToString:@"CANCELED"]){
				myCell.statusLabel.text = @"CANCELED";
				[myCell.enableTopView setAlpha:0.4];
				[myCell.enableBottomView setAlpha:0.4];
				[myCell.editButton setAlpha:1.0];
				[myCell.statusView setAlpha:0.8];
				myCell.statusView.transform = CGAffineTransformMakeRotation(-69.5);	
				
			}else if([myCell.observation.status isEqualToString:@"PENDING"]){
				//Do nothing
			}
		}
	}
}

#pragma mark -
#pragma mark DueDateCommentViewControllerDelegate

- (void)dueDateCommentDone:(id)context
{
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        [self.dueDateCommentPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [[self.dueDateCommentView view]removeFromSuperview];
    }
	
	NSString *note = [self.dueDateCommentView.noteTextView text];
	if ([note length] == 0) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Past due note is required"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		
		[alert show];
	}
	else
	{
		User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
		
		NSString *address = [NSString stringWithFormat:@"%@InProcessAuditAddPastDueComment?User=%d&occurrence=%d&comment=%@", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId, (int)self.pendingOccurrence.occurrenceId, note];
		
		address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
		NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
		
		if([json_string integerValue] < 1)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"Past due note wasn't saved. Please contact the administrator"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			
			[alert show];
		}
		else
		{
			[self.addDueDateComment setAlpha:0.0];
			[self.pendingOccurrence setPastDueComment:note];
		}
	}
	
	
}

- (void)dueDateCommentCancel:(id)context
{
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        [self.dueDateCommentPopover dismissPopoverAnimated:YES];
    }
    else
    {
        [[self.dueDateCommentView view]removeFromSuperview];
    }
    // register for keyboard notifications
	
}


#pragma mark -
#pragma mark OccurrenceCellViewControllerDelegate

-(void) occurrenceCellSaved:(NSInteger) index
{
    self.index = index;
	[NSThread detachNewThreadSelector:@selector(loadData)
						  toTarget:self
						withObject:nil];
}

-(void) occurrenceCellAddObservation:(NSInteger) index
{
    self.index = index;
    
	User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
	
	self.pendingOccurrence.numberOfObservations = self.pendingOccurrence.numberOfObservations + 1;
	[self.loader show];
	
	NSString *address = [NSString stringWithFormat:@"%@InProcessAuditAddObservation?User=%d&id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId, (int)self.pendingOccurrence.occurrenceId];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	
	if (![json_string isEqualToString:@"[]"]) {
        [NSThread detachNewThreadSelector:@selector(loadData)
								 toTarget:self
							   withObject:nil];
	}
}

-(void)SaveSelectedItem:(IPAObservation *)observationTemp
{
    for (OccurrenceCellViewController *visibleCell in [self.tableView visibleCells]) {
        [visibleCell.enteredGeneralNotes endEditing:YES];
        [visibleCell.enteredObservationValue endEditing:YES];
    }
    
    NSString *statusObservation = @"PENDING";
    
    NSString *address;
    
    NSInteger auditeeValue = observationTemp.auditee.userMasterId;
    NSInteger workCenterValue = observationTemp.workCenterId;
    NSInteger supervisorValue = observationTemp.supervisor.userMasterId;
    
    if (observationTemp.auditee.userMasterId < 1) {
        auditeeValue = 0;
    }
    
    if (observationTemp.workCenterId < 1) {
        workCenterValue = 0;
    }
    
    if (observationTemp.supervisor.userMasterId < 1) {
        supervisorValue = 0;
    }
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* number = [numberFormatter numberFromString:observationTemp.observationValue];
    if (!number) {
        observationTemp.observationValue = @"";
    }
    
    if (observationTemp.observationId == 0) {
        
        address = [NSString stringWithFormat:@"%@InProcessAuditObservationSave?User=%d&occ=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)currentUser.userMasterId,(int)self.pendingOccurrence.occurrenceId,(int)auditeeValue,(int)workCenterValue,(int)supervisorValue,observationTemp.observationValue,observationTemp.generalNotes,statusObservation,observationTemp.failType,observationTemp.notCompleteNotes, (int)observationTemp.shiftId];
    }
    else
    {
        address = [NSString stringWithFormat:@"%@InProcessAuditObservationUpdate?User=%d&obsId=%d&aud=%d&wc=%d&sup=%d&obsVal=%@&genNot=%@&st=%@&fail=%@&NoCompNot=%@&shiftId=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)currentUser.userMasterId,(int)observationTemp.observationId,(int)auditeeValue,(int)workCenterValue,(int)supervisorValue,observationTemp.observationValue,observationTemp.generalNotes,statusObservation,observationTemp.failType,observationTemp.notCompleteNotes, (int)observationTemp.shiftId];
    }
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    json_string = nil;
}


-(void)copySelectedUserItem:(User *)user
{
    if (self.observations.count > 0) {
        for (int i = 0; i < self.observations.count; i++) {
            IPAObservation *observationTemp = [self.observations objectAtIndex:i];
            NSString *statusObservation = @"PENDING";
            if ([observationTemp.status isEqualToString:statusObservation]) {
                observationTemp.supervisor = user;
                [self SaveSelectedItem:observationTemp];
            }
        }
    }
}

-(void) copySelectedWorkCenterItem:(NSInteger)workCenterId
{
    if (self.observations.count > 0) {
        for (int i = 0; i < self.observations.count; i++) {
            IPAObservation *observationTemp = [self.observations objectAtIndex:i];
            NSString *statusObservation = @"PENDING";
            if ([observationTemp.status isEqualToString:statusObservation]) {
                observationTemp.workCenterId = workCenterId;
                [self SaveSelectedItem:observationTemp];
            }
        }
    }
}

-(void) copySelectedShiftItem:(NSInteger)shiftId
{
    if (self.observations.count > 0) {
        for (int i = 0; i < self.observations.count; i++) {
            IPAObservation *observationTemp = [self.observations objectAtIndex:i];
            NSString *statusObservation = @"PENDING";
            if ([observationTemp.status isEqualToString:statusObservation]) {
                observationTemp.shiftId = shiftId;
                [self SaveSelectedItem:observationTemp];
            }
        }
    }
}


-(void) occurrenceCellAddIQP:(IPAObservation *)observation
{
    if (observation.qualityConcernId <= 0) {
        InternalQPEntryViewController *iQP = [[InternalQPEntryViewController alloc] initWithObServation:observation];
        [self.navigationController pushViewController:iQP animated:YES]; 
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to enter QP" message:@"Observation already had a QP." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = 4;
        [alert show];
    }
}

-(void) occurrenceCellCancelObservations:(NSInteger) index
{
    [self loadData];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audite Suite Alert" message:@"The occurrence has been completed successfully."delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
	[alert setTag:1];
	[alert show];
}

-(void)textFieldDidBeginEditing:(id)context
{
	if (animatedDistance > 0) {
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y += animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
		
		animatedDistance = 0;
	}
	
	if ([context isKindOfClass:[UITextField class]]) {
		UITextField *textField = (UITextField *) context;
		
		CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
		CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
		
		CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
		CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
		CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
		CGFloat heightFraction = numerator / denominator;
		
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		
		UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		if (orientation == UIInterfaceOrientationPortrait)
		{
			//animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) + 72;
			animatedDistance = 264;
		}
		else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			//animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) + 240;
			animatedDistance = 264;
		}
		else if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			//animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction) + 258;
			animatedDistance = 310;
		}
		else if (orientation == UIInterfaceOrientationLandscapeRight)
		{
			//animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction) + 307;
			animatedDistance = 310;
		}

		heightFraction = numerator / denominator;
		
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y -= animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	} 
	else if ([context isKindOfClass:[UITextView class]]) {
		UITextView *textField = (UITextView *) context;
		
		CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
		CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
		
		CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
		CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
		CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
		CGFloat heightFraction = numerator / denominator;
		
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		
		UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		if (orientation == UIInterfaceOrientationPortrait)
		{
			//animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) + 47;
			animatedDistance = 264;
		}
		else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			//animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) + 262;
			animatedDistance = 264;
		}
		else if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			//animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction) + 283;
			animatedDistance = 310;
		}
		else if (orientation == UIInterfaceOrientationLandscapeRight)
		{
			//animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction) + 280;
			animatedDistance = 310;
		}
		
		heightFraction = numerator / denominator;
		
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y -= animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	} 
	else if ([context isKindOfClass:[UISearchBar class]]) {
		UISearchBar *searchBar = (UISearchBar *) context;
		
		CGRect searchBarRect = [self.view.window convertRect:searchBar.bounds fromView:searchBar];
		CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
		
		CGFloat midline = searchBarRect.origin.y + 0.5 * searchBarRect.size.height;
		CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
		CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
		CGFloat heightFraction = numerator / denominator;
		
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		
		UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		
		if (orientation == UIInterfaceOrientationPortrait)
		{
			//animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) + 188;
			animatedDistance = 264;
		}
		else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		{
			//animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) + 125;
			animatedDistance = 264;
		}
		else if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			//animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction) + 321;
			animatedDistance = 310;
		}
		else if (orientation == UIInterfaceOrientationLandscapeRight)
		{
			//animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction) + 244;
			animatedDistance = 310;
		}
		
		heightFraction = numerator / denominator;
		
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y -= animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
}

-(void)textFieldDidEndEditing:(id)context
{
	if (animatedDistance > 0) {
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y += animatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
		
	}
	animatedDistance = 0;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex 
{
	if (buttonIndex == 0 && alertView.tag == 1)
	{
		useSaveAndExit = NO;
		UINavigationController* navController = self.navigationController;
		UIViewController* controller = [navController.viewControllers objectAtIndex:0];
		[navController popToViewController:controller animated:YES];
	}
}

@end
