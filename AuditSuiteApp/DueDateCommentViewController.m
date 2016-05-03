//
//  DueDateCommentViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DueDateCommentViewController.h"
#import "UIView+Presentation.h"

@implementation DueDateCommentViewController

@synthesize okButton;
@synthesize cancelButton;
@synthesize noteView;
@synthesize caller;
@synthesize context;
@synthesize noteTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithCaller:(id<DueDateCommentViewControllerDelegate>)_caller 
               title:(NSString *)_atitle 
          andContext:(id)_context 
{
    
    NSString *nibName = @"DueDateCommentViewController";
	
	self = [super initWithNibName:nibName bundle:nil];
    
    context = _context;
    caller = _caller;
    self.title = _atitle;
	
	
	// Custom initialization
					   
	
    return self;
}

- (IBAction)okAction:(id)sender  
{
	[self.caller dueDateCommentDone:self.context];
}

- (IBAction)cancel:(id)sender 
{
    [self.caller dueDateCommentCancel:self.context];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	self.contentSizeForViewInPopover = CGSizeMake(350, 290);
    self.preferredContentSize = CGSizeMake(350, 290);
	[noteView configureViewWithBorderColor:[UIColor lightGrayColor] BorderWith:2.00 CornerRadius:5.0f MaskBounds:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewDidUnload {
    [self setOkButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}

@end
