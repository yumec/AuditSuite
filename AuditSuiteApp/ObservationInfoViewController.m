//
//  ObservationInfoViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ObservationInfoViewController.h"

@implementation ObservationInfoViewController

@synthesize description = _description;
@synthesize descriptionId = _descriptionId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
