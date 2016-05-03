//
//  ForgotLogonViewController.m
//  SamtecFAETools
//
//  Created by Jorge Mendoza on 8/12/11.
//  Copyright 2011 Samtec, Inc. All rights reserved.
//

#import "ForgotLogonViewController.h"



@implementation ForgotLogonViewController
@synthesize emailAddressTextField;
@synthesize okButton;
@synthesize cancelButton;
@synthesize  caller;
@synthesize  context;
@synthesize errorLabel;


-(id) initWithCaller:(id<ForgotLogonViewControllerDelegate>)_caller 
               title:(NSString *)_atitle 
          andContext:(id)_context 
{
    
    NSString *nibName = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 
	@"ForgotLogon" : 
	@"ForgotLogon_iPhone";
	
	self = [super initWithNibName:nibName bundle:nil];
    
    context = _context;
    caller = _caller;
    self.title = _atitle;
    return self;
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        self.contentSizeForViewInPopover = CGSizeMake(355, 233);
    }
    else
    {
        self.view.frame = CGRectMake(38, 140, 244, 178);
        [[self emailAddressTextField] becomeFirstResponder];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self emailAddressTextField] becomeFirstResponder];
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        // Return YES for supported orientations
        return YES;
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


- (void)viewDidUnload {
    [self setEmailAddressTextField:nil];
    [self setOkButton:nil];
    [self setCancelButton:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
}
- (IBAction)okAction:(id)sender  
{
    self.errorLabel.hidden = YES;
    
    if ([self validateEmail:self.emailAddressTextField.text])
    {
                
//        NSString *urlString = [NSString stringWithFormat:@"http://faetools.samtec.com/Services/ForgotLogon.ashx?email=%@", self.emailAddressTextField.text];
//        
//        NSURL *url = [NSURL URLWithString:urlString];
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
//        
//        NSString *result = [dict objectForKey:@"result"];
//        
//        // if the transaction present errors
//        if ([[result uppercaseString] compare:@"DONE"] != NSOrderedSame)
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FAE Tools" message:@"We can't find your information, please check your email  account and try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
//            [alert release];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FAE Tools" message:@"We sent your logon information to the email address!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [[self navigationController] popToRootViewControllerAnimated:YES];
//            [alert show];
//            [alert release];
//            
//            [self.caller done:self.context];
//        }

    }
    else
    {
        self.errorLabel.hidden = NO;
    }
}

- (IBAction)cancel:(id)sender 
{
    [self.caller cancel:self.context];
}


- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
} 

@end
