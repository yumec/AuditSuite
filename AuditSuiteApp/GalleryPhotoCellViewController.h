//
//  GalleryPhotoCellViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPAObservationAttachedFile.h"
#import <UIKit/UIKit.h>

@protocol GalleryPhotoCellViewControllerDelegate

-(void) photoDeleted:(id) context;
-(void) photoChanged:(id) context;
-(void)firstPhoto:(id)context;
-(void)previousPhoto:(id)context;
-(void)nextPhoto:(id)context;
-(void)lastPhoto:(id)context;
-(void)nameDidEndEditing:(id)context;
-(void)nameDidBeginEditing:(id)context;

@end

@interface GalleryPhotoCellViewController : UITableViewCell <UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UIImageView *image;
@property(nonatomic, strong) IBOutlet UIButton *firstButton;
@property(nonatomic, strong) IBOutlet UIButton *previousButton;
@property(nonatomic, strong) IBOutlet UIButton *nextButton;
@property(nonatomic, strong) IBOutlet UIButton *lastButton;
@property(nonatomic, strong) IBOutlet UIButton *deleteButton;
@property(nonatomic, strong) IBOutlet UIButton *changeSaveButton;
@property(nonatomic, strong) IBOutlet UITextField *photoDescription;
@property(nonatomic, strong) IBOutlet UILabel *countLabel;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) NSInteger fileDetailId;
@property(nonatomic, strong) IPAObservationAttachedFile *attachedFile;

@property (nonatomic, strong) id<GalleryPhotoCellViewControllerDelegate> caller;

- (void)initWithCaller:(id<GalleryPhotoCellViewControllerDelegate>) _caller;

-(IBAction)changeName:(id)sender;
-(IBAction)deletePhoto:(id)sender;
-(IBAction)firstPhoto:(id)sender;
-(IBAction)previousPhoto:(id)sender;
-(IBAction)nextPhoto:(id)sender;
-(IBAction)lastPhoto:(id)sender;

-(IBAction)textFieldDidEndEditing:(id)sender;
-(IBAction)textFieldDidBeginEditing:(id)sender;

@end
