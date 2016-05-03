//
//  NotCompleteNotesViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotCompleteNotesViewControllerDelegate

-(void) notCompleteNotesDone:(id) context;
-(void) notCompleteNotesCancel:(id) context;

@end

@interface NotCompleteNotesViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *okButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIView *noteView;
@property (nonatomic, strong) IBOutlet UITextView *noteTextView;

@property(nonatomic, strong) id<NotCompleteNotesViewControllerDelegate> caller;
@property(nonatomic, strong) id context;

- (IBAction)okAction:(id)sender;
- (IBAction)cancel:(id)sender;

- (id)initWithCaller:(id<NotCompleteNotesViewControllerDelegate>)_caller 
              title:(NSString*)_atitle 
         andContext:(id)_context;

@end
