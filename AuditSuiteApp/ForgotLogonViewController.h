//
//  ForgotLogonViewController.h
//  SamtecFAETools
//
//  Created by Jorge Mendoza on 8/12/11.
//  Copyright 2011 Samtec, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgotLogonViewControllerDelegate

-(void) done:(id) context;
-(void) cancel:(id) context;

@end

@interface ForgotLogonViewController : UIViewController  
{
    
    UITextField *emailAddressTextField;
    UIButton *okButton;
    UIButton *cancelButton;
    
    id<ForgotLogonViewControllerDelegate> caller;
    id context;
    UILabel *errorLabel;
}
@property (nonatomic, retain) IBOutlet UITextField *emailAddressTextField;
@property (nonatomic, retain) IBOutlet UIButton *okButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@property(nonatomic, retain) id<ForgotLogonViewControllerDelegate> caller;
@property(nonatomic, retain) id context;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;

- (IBAction)okAction:(id)sender;
- (IBAction)cancel:(id)sender;


-(id)initWithCaller:(id<ForgotLogonViewControllerDelegate>)_caller 
              title:(NSString*)_atitle 
         andContext:(id)_context;

- (BOOL)validateEmail:(NSString *)email;

@end
