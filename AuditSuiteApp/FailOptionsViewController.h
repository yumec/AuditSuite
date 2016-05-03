//
//  FailOptionsViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FailOptionsViewControllerDelegate

-(void) failOptionsDone:(id) context;
-(void) failOptionsCancel:(id) context;

@end

@interface FailOptionsViewController : UIViewController
{
	UIButton *_machine;
	UIButton *_man;
	UIButton *_material;
	UIButton *_method;
	UIButton *_environmental;
}

@property (nonatomic, strong) IBOutlet UIButton *machine;
@property (nonatomic, strong) IBOutlet UIButton *man;
@property (nonatomic, strong) IBOutlet UIButton *material;
@property (nonatomic, strong) IBOutlet UIButton *method;
@property (nonatomic, strong) IBOutlet UIButton *environmental;

@property (nonatomic, strong) IBOutlet UIButton *okButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

@property(nonatomic, strong) id<FailOptionsViewControllerDelegate> caller;
@property(nonatomic, strong) id context;

- (IBAction)checkboxButton:(UIButton *)button;
- (IBAction)okAction:(id)sender;
- (IBAction)cancel:(id)sender;

-(id)initWithCaller:(id<FailOptionsViewControllerDelegate>)_caller 
              title:(NSString*)_atitle 
         andContext:(id)_context;

@end
