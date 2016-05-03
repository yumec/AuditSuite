//
//  RecentDefectCellViewController.h
//  AuditSuiteApp
//
//  Created by hz-yumec on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentDefectCellViewController : UITableViewCell
{
    UILabel *qualityConcernId;
    UILabel *isInternal;
    UILabel *dateEntered;
    UILabel *enteredBy;
    UILabel *status;
    UILabel *samtecPartMasterDescription;
    UILabel *defect;
    UILabel *defectsCount;
    UILabel *purchaseOrderNumber;
    UILabel *orderNumber;
    UILabel *pcMfgOrderNum;
    UILabel *lineNumber;
    UILabel *quantityShipped;
    UILabel *submitedByLocationId;
    UILabel *submitedByLocationName;
    UILabel *reportingCustomerId;
    UILabel *reportingCustomerName;
}

@property (nonatomic, strong) IBOutlet UILabel *qualityConcernId;
@property (nonatomic, strong) IBOutlet UILabel *isInternal;
@property (nonatomic, strong) IBOutlet UILabel *dateEntered;
@property (nonatomic, strong) IBOutlet UILabel *enteredBy;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UILabel *samtecPartMasterDescription;
@property (nonatomic, strong) IBOutlet UILabel *defect;
@property (nonatomic, strong) IBOutlet UILabel *defectsCount;
@property (nonatomic, strong) IBOutlet UILabel *purchaseOrderNumber;
@property (nonatomic, strong) IBOutlet UILabel *orderNumber;
@property (nonatomic, strong) IBOutlet UILabel *pcMfgOrderNum;
@property (nonatomic, strong) IBOutlet UILabel *lineNumber;
@property (nonatomic, strong) IBOutlet UILabel *quantityShipped;
@property (nonatomic, strong) IBOutlet UILabel *submitedByLocationId;
@property (nonatomic, strong) IBOutlet UILabel *submitedByLocationName;
@property (nonatomic, strong) IBOutlet UILabel *reportingCustomerId;
@property (nonatomic, strong) IBOutlet UILabel *reportingCustomerName;

@end
