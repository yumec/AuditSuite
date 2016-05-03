//
//  GalleryPhotoCellViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GalleryPhotoCellViewController.h"

@implementation GalleryPhotoCellViewController

@synthesize image;
@synthesize firstButton;
@synthesize previousButton;
@synthesize nextButton;
@synthesize lastButton;
@synthesize deleteButton;
@synthesize changeSaveButton;
@synthesize description;
@synthesize countLabel;
@synthesize count;
@synthesize attachedFile;
@synthesize index;
@synthesize fileDetailId;

@synthesize caller;

- (void)initWithCaller:(id<GalleryPhotoCellViewControllerDelegate>) _caller
{
	caller = _caller;
	[self.changeSaveButton setTitle:@"Change" forState:UIControlStateNormal];
	[self.changeSaveButton setTitle:@"Save" forState:UIControlStateSelected];
	
	[self.changeSaveButton setSelected:NO];
	
	self.countLabel.text = [NSString stringWithFormat: @"%d/%d",(int)index, (int)count];
}

-(IBAction)changeName:(id)sender
{
	if (!self.changeSaveButton.isSelected) {
		self.photoDescription.enabled = YES;
		[self.photoDescription setAlpha:1.0];
		[self.changeSaveButton setSelected:YES];
		
		[self.photoDescription becomeFirstResponder];
	}
	else
	{
		self.photoDescription.enabled = NO;
		[self.photoDescription setAlpha:0.70];
		[self.changeSaveButton setSelected:NO];
		
		[self.caller photoChanged:self];
	}
}

-(IBAction)deletePhoto:(id)sender
{
	[self.caller photoDeleted:self];
}

-(IBAction)firstPhoto:(id)sender
{
	[self.caller firstPhoto:self];
}

-(IBAction)previousPhoto:(id)sender
{
	[self.caller previousPhoto:self];
}

-(IBAction)nextPhoto:(id)sender
{
	[self.caller nextPhoto:self];
}

-(IBAction)lastPhoto:(id)sender
{
	[self.caller lastPhoto:self];
}

-(IBAction)textFieldDidBeginEditing:(id)sender
{
	[self.caller nameDidBeginEditing:sender];
}

-(IBAction)textFieldDidEndEditing:(id)sender
{
	[self.caller nameDidEndEditing:sender];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
//{
//    
//	NSCharacterSet *controlSet = [NSCharacterSet controlCharacterSet];
//    
//	if (![string stringByTrimmingCharactersInSet:controlSet].length > 0) {
//		return YES;
//	}
//
//	controlSet = [NSCharacterSet alphanumericCharacterSet];
//	
//	return (![string stringByTrimmingCharactersInSet:controlSet].length > 0);
//    
//    return YES;
//}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	
	self.photoDescription.enabled = NO;
	[self.photoDescription setAlpha:0.70];
	[self.changeSaveButton setSelected:NO];
	[self.caller photoChanged:self];
	
	return YES;
}


@end
