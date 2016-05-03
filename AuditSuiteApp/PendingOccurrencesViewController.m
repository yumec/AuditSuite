//
//  PendingOccurrencesCellViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PendingOccurrencesViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "IPAPendingOccurrence.h"
#import "PendingOccurrencesCellViewController.h"
#import "DecimalFormatter.h"
#import "OccurrenceViewController.h"
#import "LogonViewController.h"
#import "JSON.h"

@implementation PendingOccurrencesViewController

#pragma mark -
#pragma mark Properties

@synthesize occurrences = _occurrences;
@synthesize loader = _loader;
@synthesize tableView = _tableView;
@synthesize totalsView = _totalsView; 
@synthesize overdue = _overdue;
@synthesize today = _today;
@synthesize next = _next;
@synthesize currentVersionLabel = _currentVersionLabel;
@synthesize currentUserLabel = _currentUserLabel;
@synthesize refreshView = _refreshView;
@synthesize logoutView = _logoutView;
@synthesize firstOfToday = _firstOfToday;

#pragma mark -
#pragma mark Initialization


- (void)becomeActive:(NSNotification *)notification {
	
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentUser:nil];
	
	if (![self isEqual: [self.navigationController visibleViewController]]) 
	{
		UINavigationController* navController = self.navigationController;
		UIViewController* controller = [navController.viewControllers objectAtIndex:0];
		[navController popToViewController:controller animated:YES];
	}
	
	[self viewDidAppear:true];
}


- (IBAction)refreshPendingOccurrences:(id)sender
{		
	[self.loader show];
	
	[NSThread detachNewThreadSelector:@selector(loadData)
							 toTarget:self
						   withObject:nil];
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(becomeActive:)
//												 name:UIApplicationDidBecomeActiveNotification
//											   object:nil];

    [[self navigationItem] setTitle:@"Pending Audits"];
    
    self.loader = [[ActivityAlertView alloc] initWithMessage:@"Pending Audits..."];
    
    [self.totalsView makeCornersRound];
	[self.refreshView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:10.0f MaskBounds:YES];
    [self.logoutView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:0.00 CornerRadius:10.0f MaskBounds:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];	
	
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
	User *u = appDelegate.currentUser;
              
	if (!u)
	{		
		LogonViewController *logon = [[LogonViewController alloc] init];
		[logon setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		
		[self presentViewController:logon animated:YES completion:^{}];
		
		return;
	}
	
	[self.loader show];
    
    
	[NSThread detachNewThreadSelector:@selector(loadData)
							 toTarget:self
						   withObject:nil];
    
	self.currentUserLabel.text = [NSString stringWithFormat:@"Current User: %@", u.fullName];
	self.currentVersionLabel.text = [NSString stringWithFormat:@"%@ (Environment : %@)", appDelegate.currentVersion, appDelegate.currentEnvironment];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

#pragma mark -
#pragma mark Threading Messages

- (void) loadData
{
	User *u = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
	self.firstOfToday = nil;
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSString *address = [NSString stringWithFormat:@"%@GetInProcessAuditPendingOccurrences?id=%d", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], (int)u.userMasterId];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	NSArray *occ = [parser objectWithString:json_string error:nil];
	self.occurrences = nil;
    
	self.occurrences = [NSMutableArray arrayWithCapacity:[occ count]];

    self.next.text = @"0";
    self.overdue.text = @"0";
    self.today.text = @"0";
    
	NSInteger occCount = 0;
    for(NSDictionary *f in occ)
    {
        IPAPendingOccurrence *tmp = [IPAPendingOccurrence iPAPendingOccurrenceWithDictionary:f];
        [self.occurrences addObject:tmp];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        
        NSDate *today = [NSDate date];
        
        NSComparisonResult result = [[df stringFromDate: today] compare: [df stringFromDate: [tmp occurrenceDate]]]; // comparing two 
        
        if(result==NSOrderedAscending){
            //today is less
            self.next.text = [NSString stringWithFormat:@"%d", (int)[[self.next text] integerValue] + 1];
			
			if (self.firstOfToday == nil) 
			{
				self.firstOfToday = [NSIndexPath indexPathForRow:occCount inSection:0];
			}
        }
        else if(result==NSOrderedDescending){
            //newDate is less
            self.overdue.text = [NSString stringWithFormat:@"%d", (int)[[self.overdue text] integerValue] + 1];
        }
        else{
            //Both dates are same
            self.today.text = [NSString stringWithFormat:@"%d", (int)[[self.today text] integerValue] + 1];
			
			if (self.firstOfToday == nil) 
			{
				self.firstOfToday = [NSIndexPath indexPathForRow:occCount inSection:0];
			}
        }
		occCount += 1;
    }
    
	[self performSelectorOnMainThread:@selector(finish)
						   withObject:nil
						waitUntilDone:NO];
}

- (void)finish
{
	[self.tableView reloadData];
	[self.loader close];
	
	[self.tableView scrollToRowAtIndexPath:self.firstOfToday atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTotalsView:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [self.occurrences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    
    static NSString *CellIdentifier = @"Cell";
    NSString *nibName = @"PendingOccurrencesCellViewController";
    
    PendingOccurrencesCellViewController *cell = (PendingOccurrencesCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
		for (id currentObject in topLevelObjects) 
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (PendingOccurrencesCellViewController *)currentObject;
				break;
			}
		}
    }
    
    IPAPendingOccurrence *f = [self.occurrences objectAtIndex:indexPath.row];    
	
    cell.DueDate.text = [f occurrenceDateStr];
    cell.Area.text = [[f area] description];
    cell.Type.text = [[f auditType] description];
    cell.Focus.text = [[f focus] description];
    cell.Obs.text = [NSString stringWithFormat:@"%d/%d", (int)[f numberOfObservationsRemaining], (int)[f numberOfObservations]];
    cell.Instruction.text = [f instruction];
    cell.LeadAuditor.text = [[f leadAuditor] fullName];
    cell.OriginalDueDate = (NSDate *) [f occurrenceDate];    
	cell.AuditId.text = [NSString stringWithFormat:@"%d", (int)f.seriesId];
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    IPAPendingOccurrence *i = [self.occurrences objectAtIndex:indexPath.row];
    OccurrenceViewController *occurrence = [[OccurrenceViewController alloc] initWithPendingOccurrence:i];
    [self.navigationController pushViewController:occurrence animated:YES]; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    
    NSDate *today = [NSDate date];
    
    NSComparisonResult result = [[df stringFromDate: today] compare: [df stringFromDate: [(PendingOccurrencesCellViewController *)cell OriginalDueDate]]]; // comparing two 
    
    if(result==NSOrderedAscending)
        //today is less
        cell.backgroundColor = [UIColor lightGrayColor];
    else if(result==NSOrderedDescending)
        //newDate is less
        cell.backgroundColor = [UIColor orangeColor];
    else
        //Both dates are same
        cell.backgroundColor = [UIColor whiteColor];
}

- (IBAction)logout:(id)sender
{
    NSString *path = [(AppDelegate *)[[UIApplication sharedApplication] delegate] documentsDirectoryPath];

    NSString *fullPath = [path stringByAppendingPathComponent:@"userinfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fullPath error:NULL];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentUser:nil];
    
    LogonViewController *logon = [[LogonViewController alloc] init];
    [logon setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:logon animated:YES completion:^{}];

}

@end
