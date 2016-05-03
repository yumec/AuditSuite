//
//  ObservationInfoViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObservationInfoViewController : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *description;
@property (nonatomic, assign) NSInteger descriptionId;

@end
