//
//  OccurrenceCellViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationInfoViewController.h"
#import "ActivityAlertView.h"
#import "UIView+Presentation.h"
#import "FailOptionsViewController.h"
#import "NotCompleteNotesViewController.h"
#import "IPAObservation.h"
#import "IPAPendingOccurrence.h"
#import "GalleryPhotoCellViewController.h"

@protocol OccurrenceCellViewControllerDelegate

-(void)occurrenceCellSaved:(NSInteger) index;
-(void)occurrenceCellAddObservation:(NSInteger) index;
-(void)occurrenceCellCancelObservations:(NSInteger) index;
-(void)textFieldDidEndEditing:(id)context;
-(void)textFieldDidBeginEditing:(id)context;
-(void)openAddPastDueDateComment:(id)context;
-(void)occurrenceCellAddIQP:(IPAObservation *)observation;

-(void)copySelectedUserItem:(User *)user;
-(void)copySelectedWorkCenterItem:(NSInteger)workCenterId;
-(void)copySelectedShiftItem:(NSInteger)shiftId;

@end

@interface OccurrenceCellViewController : UITableViewCell <FailOptionsViewControllerDelegate, NotCompleteNotesViewControllerDelegate, UISearchBarDelegate, UIAlertViewDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UITextViewDelegate, GalleryPhotoCellViewControllerDelegate, UITextFieldDelegate>
{
	UIView *headerView;
	UIView *headerNotesView;
	UIView *auditeeView;
	UIView *selectedAuditeeView;
	UIView *workCenterView;
	UIView *selectedWorkCenterView;
	UIView *supervisorView;
	UIView *selectedSupervisorView;
    UIView *shiftView;
    UIView *selectedShiftView;
    
	UIView *galleryView;
	
	UILabel *occurrenceCount;
	UILabel *observationValue;
	UILabel *statusLabel;
	UILabel *selectedAuditeeLabel;
	UILabel *selectedWorkCenterLabel;
	UILabel *selectedSupervisorLabel;
	UILabel *selectedShiftLabel;
    
	UIView *buttonView;
	UIView *enableTopView;
	UIView *enableBottomView;
	UIView *statusView;
	UIButton *editButton;
	UIButton *auditeeButton;
	UIButton *workCenterButton;
	UIButton *supervisorButton;
    UIButton *shiftButton;
    UIButton *passButton;
    UIButton *failButton;
    UIButton *notCompleteButton;
    
    
	UISearchBar *_auditeeSearchBar;
	UISearchBar *_workCenterSearchBar;
	UISearchBar *_supervisorSearchBar;
    UISearchBar *_shiftSearchBar;
    
	BOOL _auditeeSearching;
	BOOL _workCenterSearching;
	BOOL _supervisorSearching;
	UIImageView *_auditeeImage;
	UIImageView *_workCenterImage;
	UIImageView *_supervisorImage;
    UIImageView *_shiftImage;
	UIImageView *_observationValueImage;
	UIImageView *_generalNotesImage;
	UIImageView *_backgroundImage;
	
	ActivityAlertView *_loader;
	IPAObservation *_observation;
	IPAPendingOccurrence *_pendingOccurrence;
	
	NSInteger _index;
	ObservationInfoViewController *_selectedAuditee;
	ObservationInfoViewController *_selectedWorkCenter;
	ObservationInfoViewController *_selectedSupervisor;
    ObservationInfoViewController *_selectedShift;
    
	UITextField *_enteredObservationValue;
	UITextView *_enteredGeneralNotes;
//	NSInteger _countChanges;
	
	UIPopoverController *_imagePickerPopover;
	
//	NSMutableData *responseData;
    NSInteger _currentObservationIndex;
}

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *headerNotesView;
@property (nonatomic, strong) IBOutlet UIView *auditeeView;
@property (nonatomic, strong) IBOutlet UIView *selectedAuditeeView;
@property (nonatomic, strong) IBOutlet UIView *workCenterView;
@property (nonatomic, strong) IBOutlet UIView *selectedWorkCenterView;
@property (nonatomic, strong) IBOutlet UIView *supervisorView;
@property (nonatomic, strong) IBOutlet UIView *shiftView;
@property (nonatomic, strong) IBOutlet UIView *selectedShiftView;
@property (nonatomic, strong) IBOutlet UIView *selectedDayofView;
@property (nonatomic, strong) IBOutlet UIView *selectedSupervisorView;
@property (nonatomic, strong) IBOutlet UIView *galleryView;
@property (nonatomic, strong) IBOutlet UIView *galleryViewEnabled;
@property (nonatomic, strong) IBOutlet UILabel *occurrenceCount;
@property (nonatomic, strong) IBOutlet UILabel *observationValue;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *selectedAuditeeLabel;
@property (nonatomic, strong) IBOutlet UILabel *selectedWorkCenterLabel;
@property (nonatomic, strong) IBOutlet UILabel *selectedSupervisorLabel;
@property (nonatomic, strong) IBOutlet UILabel *selectedShiftLabel;
@property (nonatomic, strong) IBOutlet UIView *buttonView;
@property (nonatomic, strong) IBOutlet UIView *enableTopView;
@property (nonatomic, strong) IBOutlet UIView *enableBottomView;
@property (nonatomic, strong) IBOutlet UIView *statusView;
@property (nonatomic, strong) IBOutlet UIButton *editButton;
@property (nonatomic, strong) IBOutlet UIButton *auditeeButton;
@property (nonatomic, strong) IBOutlet UIButton *workCenterButton;
@property (nonatomic, strong) IBOutlet UIButton *supervisorButton;
@property (nonatomic, strong) IBOutlet UIButton *shiftButton;
@property (nonatomic, strong) UISearchBar *auditeeSearchBar;
@property (nonatomic, strong) UISearchBar *workCenterSearchBar;
@property (nonatomic, strong) UISearchBar *supervisorSearchBar;
@property (nonatomic, strong) UISearchBar *shiftSearchBar;
@property (nonatomic, strong) IBOutlet UIImageView *auditeeImage;
@property (nonatomic, strong) IBOutlet UIImageView *workCenterImage;
@property (nonatomic, strong) IBOutlet UIImageView *supervisorImage;
@property (nonatomic, strong) IBOutlet UIImageView *shiftImage;
@property (nonatomic, strong) IBOutlet UIImageView *observationValueImage;
@property (nonatomic, strong) IBOutlet UIImageView *generalNotesImage;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, strong) ActivityAlertView *loader;
@property (nonatomic, strong) IPAObservation *observation;
@property (nonatomic, strong) IPAPendingOccurrence *pendingOccurrence;
@property (nonatomic, strong) NSMutableArray *usersFacility;
@property (nonatomic, strong) NSMutableArray *workCenters;
@property (nonatomic, strong) NSMutableArray *auditeeUsersCopy;
@property (nonatomic, strong) NSMutableArray *workCentersCopy;
@property (nonatomic, strong) NSMutableArray *shiftList;
@property (nonatomic, strong) NSMutableArray *supervisorUsersCopy;
@property (nonatomic, strong) NSMutableArray *shiftCopy;

//@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) IBOutlet UITableView *auditeeTableView;
@property (nonatomic, strong) IBOutlet UITableView *supervisorsTableView;
@property (nonatomic, strong) IBOutlet UITableView *workCentersTableView;
@property (nonatomic, strong) IBOutlet UITableView *shiftTableView;
@property (nonatomic, strong) IBOutlet UITableView *imagesTableView;

@property (nonatomic, strong) FailOptionsViewController *failOptionsView;
@property (nonatomic, strong) UIPopoverController *failOptionsPopover;
@property (nonatomic, strong) NotCompleteNotesViewController *notCompleteNotesView;
@property (nonatomic, strong) UIPopoverController *notCompleteNotesPopover;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) ObservationInfoViewController *selectedAuditee;
@property (nonatomic, strong) ObservationInfoViewController *selectedWorkCenter;
@property (nonatomic, strong) ObservationInfoViewController *selectedSupervisor;
@property (nonatomic, strong) ObservationInfoViewController *selectedShift;

@property (nonatomic, strong) IBOutlet UITextField *enteredObservationValue;
@property (nonatomic, strong) IBOutlet UITextView *enteredGeneralNotes;

@property (nonatomic, strong) IBOutlet UILabel *loadingPicturesLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) id<OccurrenceCellViewControllerDelegate> caller;
@property (nonatomic, strong) IBOutlet UIButton *addInternalQP;
@property (nonatomic, strong) IBOutlet UILabel *internalQP;
@property (nonatomic, strong) IBOutlet UIButton *passButton;
@property (nonatomic, strong) IBOutlet UIButton *failButton;
@property (nonatomic, strong) IBOutlet UIButton *notCompleteButton;
@property (nonatomic, assign) NSInteger currentObservationIndex;


- (IBAction)FailAction:(id)sender;
- (IBAction)NotCompleteNotesAction:(id)sender;
- (IBAction)PassAction:(id)sender;
- (IBAction)EditAction:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)addIPAObservation:(id)sender;
- (IBAction)cancelObservations:(id)sender;
- (void)initWithLoadData:(IPAPendingOccurrence *) pendOcc withCaller:(id<OccurrenceCellViewControllerDelegate>) _caller;
- (IBAction)SelectAWCSAction:(id)sender;
- (void)searchAuditeeTableView;
- (void)searchWorkCenterTableView;
- (void)searchSupervisorTableView;
- (BOOL)savePictures;
//- (void) SaveAndExit;

-(IBAction)textFieldDidEndEditing:(id)sender;
-(IBAction)textFieldDidBeginEditing:(id)sender;
//-(BOOL) hasChanges;

- (IBAction) AddInternalQP:(id)sender;
- (void) loadPicture: (NSInteger) fileGroupID;
@end
