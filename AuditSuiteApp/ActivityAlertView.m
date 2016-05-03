//
//  ActivityAlertView.m
//  AuditSuiteApp
//
//  Created by Esteban Torres Hernández on 11/25/10.
//  Copyright 2010 Samtec, Inc. All rights reserved.
//

#import "ActivityAlertView.h"


@implementation ActivityAlertView

- (id) initWithMessage:(NSString *)message
{
	self = [super initWithTitle:@"Loading…" 
						message:message 
					   delegate:nil
			  cancelButtonTitle:nil
			  otherButtonTitles:nil];
	
	if (self) {
		loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 100, 33, 33)];
		[loader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[loader setHidesWhenStopped:YES];
		
		[self addSubview:loader];
	}
	
	return self;
}

- (void) show
{
	[loader startAnimating];
	[super show];
}

- (void) close
{
	[loader stopAnimating];
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
