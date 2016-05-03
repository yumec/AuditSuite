//
//  FailOptionsViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FailOptionsViewController.h"

@implementation FailOptionsViewController

@synthesize machine = _machine;
@synthesize man = _man;
@synthesize material = _material;
@synthesize method = _method;
@synthesize environmental = _environmental;
@synthesize okButton;
@synthesize cancelButton;
@synthesize caller;
@synthesize context;



-(id) initWithCaller:(id<FailOptionsViewControllerDelegate>)_caller 
               title:(NSString *)_atitle 
          andContext:(id)_context 
{
    
    NSString *nibName = @"FailOptionsViewController";
	
	self = [super initWithNibName:nibName bundle:nil];
    
    context = _context;
    caller = _caller;
    self.title = _atitle;
	
	
	// Custom initialization
	int framex =0;
	framex= 250/1;
	int framey = 0;
	framey =300/(5/(1));
	int rem =5%1;
	if(rem !=0)
	{		
		framey =300/((5/1)+1);
	}	

	int x = framex*0.25;
	int y = framey*0.25;
	
	for(int i=0;i<(5/1);i++){
		for(int j=0;j<1;j++){
			
			if (i==0)
				y += framey*0.40;
			else
				y += framey*0.65;
			
			switch (i) {
				case 0:
					
					self.machine = [[UIButton alloc] initWithFrame:CGRectMake(framex*0+x, framey*0+y,140, 37)];
					[self.machine addTarget:self action:@selector(checkboxButton:)forControlEvents:UIControlEventTouchUpInside];
					self.machine.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
					[self.machine setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
					[self.machine setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
					[self.machine setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
					[self.machine setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
					self.machine.titleLabel.font =[UIFont systemFontOfSize:14.f];
					[self.machine setTitle:@"Machine" forState:UIControlStateNormal];
					[self.machine setTitle:@"Machine" forState:UIControlStateSelected];
					[self.machine setSelected:NO];
					
					break;
				case 1:
					
					self.man = [[UIButton alloc] initWithFrame:CGRectMake(framex*0+x, framey*0+y,140, 37)];
					[self.man addTarget:self action:@selector(checkboxButton:)forControlEvents:UIControlEventTouchUpInside];
					self.man.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
					[self.man setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
					[self.man setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
					[self.man setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
					[self.man setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
					self.man.titleLabel.font =[UIFont systemFontOfSize:14.f];
					[self.man setTitle:@"Man" forState:UIControlStateNormal];
					[self.man setTitle:@"Man" forState:UIControlStateSelected];
					[self.man setSelected:NO];
					
					break;
				case 2:
					
					self.material = [[UIButton alloc] initWithFrame:CGRectMake(framex*0+x, framey*0+y,140, 37)];
					[self.material addTarget:self action:@selector(checkboxButton:)forControlEvents:UIControlEventTouchUpInside];
					self.material.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
					[self.material setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
					[self.material setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
					[self.material setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
					[self.material setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
					self.material.titleLabel.font =[UIFont systemFontOfSize:14.f];
					[self.material setTitle:@"Material" forState:UIControlStateNormal];
					[self.material setTitle:@"Material" forState:UIControlStateSelected];
					[self.material setSelected:NO];
					
					break;
				case 3:
					
					self.method = [[UIButton alloc] initWithFrame:CGRectMake(framex*0+x, framey*0+y,140, 37)];
					[self.method addTarget:self action:@selector(checkboxButton:)forControlEvents:UIControlEventTouchUpInside];
					self.method.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
					[self.method setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
					[self.method setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
					[self.method setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
					[self.method setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
					self.method.titleLabel.font =[UIFont systemFontOfSize:14.f];
					[self.method setTitle:@"Method" forState:UIControlStateNormal];
					[self.method setTitle:@"Method" forState:UIControlStateSelected];
					[self.method setSelected:NO];
					
					break;
				case 4:
					
					self.environmental = [[UIButton alloc] initWithFrame:CGRectMake(framex*0+x, framey*0+y,140, 37)];
					[self.environmental addTarget:self action:@selector(checkboxButton:)forControlEvents:UIControlEventTouchUpInside];
					self.environmental.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
					[self.environmental setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
					[self.environmental setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
					[self.environmental setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
					[self.environmental setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
					self.environmental.titleLabel.font =[UIFont systemFontOfSize:14.f];
					[self.environmental setTitle:@"Environment" forState:UIControlStateNormal];
					[self.environmental setTitle:@"Environment" forState:UIControlStateSelected];
					[self.environmental setSelected:NO];
					
					break;
					
				default:
					break;
			}
			

		}
	}
	
	[self.view addSubview:self.machine];
	[self.view addSubview:self.man];
	[self.view addSubview:self.material];
	[self.view addSubview:self.method];
	[self.view addSubview:self.environmental]; 
	
    return self;
}

- (IBAction)checkboxButton:(UIButton *)button{
	
	for (UIButton *but in [self.view subviews]) {
		if ([but isKindOfClass:[UIButton class]] && ![but isEqual:button]) {
			[but setSelected:NO];
		}
	}
	if (!button.selected) {
		button.selected = !button.selected;
	}
}

- (IBAction)okAction:(id)sender  
{
	[self.caller failOptionsDone:self.context];
}

- (IBAction)cancel:(id)sender 
{
    [self.caller failOptionsCancel:self.context];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//	self.contentSizeForViewInPopover = CGSizeMake(273, 297);
    self.preferredContentSize = CGSizeMake(273, 297);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewDidUnload {
    [self setOkButton:nil];
    [self setCancelButton:nil];
	[self setMachine:nil];
	[self setMan:nil];
	[self setMaterial:nil];
	[self setMethod:nil];
	[self setEnvironmental:nil];
    [super viewDidUnload];
}

@end
