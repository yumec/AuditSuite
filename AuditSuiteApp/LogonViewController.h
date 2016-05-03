//
//  LogonViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Presentation.h"

@interface LogonViewController : UIViewController
{
	IBOutlet UITextField *systemIDTextField;
	IBOutlet UIView *textFieldView;
	BOOL keyboardIsShown;
	UILabel *_currentVersionLabel;
}

@property (nonatomic, strong) IBOutlet UIView *keyboard;
@property (nonatomic, strong) IBOutlet UILabel *currentVersionLabel;

- (IBAction)logon;
- (IBAction)btnTapped:(id)sender;

@end

