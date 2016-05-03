//
//  RecentDefectCellViewController.m
//  AuditSuiteApp
//
//  Created by hz-yumec on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentDefectCellViewController.h"

@implementation RecentDefectCellViewController

@synthesize qualityConcernId;
@synthesize isInternal;
@synthesize dateEntered;
@synthesize enteredBy;
@synthesize status;
@synthesize samtecPartMasterDescription;
@synthesize defect;
@synthesize defectsCount;
@synthesize purchaseOrderNumber;
@synthesize orderNumber;
@synthesize pcMfgOrderNum;
@synthesize lineNumber;
@synthesize quantityShipped;
@synthesize submitedByLocationId;
@synthesize submitedByLocationName;
@synthesize reportingCustomerId;
@synthesize reportingCustomerName;

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
