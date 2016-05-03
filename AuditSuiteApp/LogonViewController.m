//
//  LogonViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LogonViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "JSON.h"

@implementation LogonViewController

@synthesize keyboard = _keyboard;
@synthesize currentVersionLabel = _currentVersionLabel;

- (id)init
{
	NSString *nibName =@"LogonViewController";
	
	self = [super initWithNibName:nibName bundle:nil];
	
	return self;	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[textFieldView makeCornersRound];
	[self.keyboard makeCornersRound];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
	[systemIDTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
	
	self.currentVersionLabel.text = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentVersion];
}

- (void)viewWillDisappear:(BOOL)animated
{
	// unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (void)logon
{		
	SBJSON *parser = [[SBJSON alloc] init];
	NSString *address = [NSString stringWithFormat:@"%@GetUserByUserId?id=%@", [(AppDelegate *)[[UIApplication sharedApplication] delegate] serverPath], systemIDTextField.text];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: address]];
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	NSDictionary *result = [parser objectWithString:json_string error:nil];
    
	if (result){
//		[(AppDelegate *)[[UIApplication sharedApplication] delegate] setCurrentUser:[User userWithDictionary:result]];
		
        NSString *path = [(AppDelegate *) [[UIApplication sharedApplication] delegate] documentsDirectoryPath];
        NSString *fullPath = [path stringByAppendingPathComponent:@"userinfo.plist"];
        [result writeToFile:fullPath atomically:YES];
        
        [self dismissViewControllerAnimated:YES completion:^{}];
	}
	else
	{
		// Logon failed
		systemIDTextField.backgroundColor = [UIColor redColor];
	}		
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
}

- (IBAction)btnTapped:(id)sender
{
    UIButton *btn = sender;

	if (btn.tag == 10) {
		//Erase
		if ([systemIDTextField.text length] > 0)
			systemIDTextField.text = [NSString stringWithFormat:@"%@", [systemIDTextField.text substringToIndex:[systemIDTextField.text length] - 1]];
	} else if(btn.tag == 11){
		//Login
		[self logon];
	} else
	{
		systemIDTextField.text = [NSString stringWithFormat:@"%@%d",systemIDTextField.text, (int)btn.tag];
	}
}


#pragma mark -
#pragma mark - Move UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *touchedView = [touch view];
    
    if([touchedView tag] == 100)
    {
		touchedView.alpha = 0.5;
		
		[[self view] bringSubviewToFront:touchedView];		
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *touchedView = [touch view];
    
    if([touchedView tag] == 100)
    {
        CGPoint currlocation = [touch locationInView:[self view]];
        CGPoint prevLocation = [touch previousLocationInView:[self view]];
        
        CGPoint location = [touchedView center];
        location.x += currlocation.x - prevLocation.x;
        location.y += currlocation.y - prevLocation.y;
        
        [touchedView setCenter:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
    UIView *touchedView = [touch view];
	
	if([touchedView tag] == 100)
		[[touch view] setAlpha:1.0];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *touchedView = [touch view];
	
	if([touchedView tag] == 100)
		[[touch view] setAlpha:1.0];
}

@end
