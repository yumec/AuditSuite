//  LMBSlidingViewController.h
//  ImmApp
//
//  Created by Esteban Torres Hernández on 1/31/11.
//  Copyright 2011 Little Maven Bird. All rights reserved.

//  Set the "tag" value of all the textfields in incremental order for the controller to
//  automatically navigate between them in logical order when pressing the "return" key

#import "LMBSlidingViewController.h"

@implementation LMBSlidingViewController


#pragma mark -
#pragma mark Constants declaration

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 256;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 360;
static const CGFloat SpaceHeight = 40;
#pragma mark -
#pragma mark Normal life cycle

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Sliding Views implementation [UITextFieldDelegate implementation]

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
	CGRect textFieldRect =	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =	[self.view.window convertRect:self.view.bounds fromView:self.view];
	
        if (orientation == UIInterfaceOrientationLandscapeLeft ) {
            textFieldRect.origin.y = textFieldRect.origin.x - SpaceHeight ; // Adding 50p because of the Navigation bar
            textFieldRect.size.height = textFieldRect.size.width - SpaceHeight ;
            viewRect.size.height = viewRect.size.width  - SpaceHeight;
             viewRect.origin.y = viewRect.origin.y + SpaceHeight;
        } else if (orientation == UIInterfaceOrientationLandscapeRight ) {
            textFieldRect.origin.y = viewRect.size.width - textFieldRect.origin.x - SpaceHeight; 
            textFieldRect.size.height = textFieldRect.size.width - SpaceHeight;
            viewRect.size.height = viewRect.size.width - SpaceHeight;
             viewRect.origin.y = viewRect.origin.y + SpaceHeight;
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            textFieldRect.origin.y = viewRect.size.height - textFieldRect.origin.y;
        }    
        
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height  ;
    CGFloat numerator =	midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)	* viewRect.size.height;
        
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
	
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{

	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
	//NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = nil;
	
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
	}
	
	return NO; 
}


# pragma mark -- UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

	CGRect textFieldRect =	[self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = 	[self.view.window convertRect:self.view.bounds fromView:self.view];
        
        if (orientation == UIInterfaceOrientationLandscapeLeft ) {
            textFieldRect.origin.y = textFieldRect.origin.x - 50; // Adding 50p because of the Navigation bar
            textFieldRect.size.height = textFieldRect.size.width - 50;
            viewRect.size.height = viewRect.size.width - 50;
            viewRect.origin.y = viewRect.origin.y + 40;
        } else if (orientation == UIInterfaceOrientationLandscapeRight ) {
            textFieldRect.origin.y =viewRect.size.width - textFieldRect.origin.x - 50; 
            textFieldRect.size.height = textFieldRect.size.width - 50;
            viewRect.size.height = viewRect.size.width - 50;
              viewRect.origin.y = viewRect.origin.y + 40;
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            textFieldRect.origin.y = viewRect.size.height - textFieldRect.origin.y;
        }    

        
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
        
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void) textViewDidEndEditing:(UITextView *)textView{
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
