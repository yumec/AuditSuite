//
//  IPAIQPRecentDefect.m
//  AuditSuiteApp
//
//  Created by hz-yumec on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPAIQPRecentDefect.h"

@implementation IPAIQPRecentDefect

@synthesize qualityConcernId = _qualityConcernId;
@synthesize isInternal = _isInternal;
@synthesize dateEntered = _dateEntered;
@synthesize enteredBy = _enteredBy;
@synthesize status = _status;
@synthesize samtecPartMasterDescription = _samtecPartMasterDescription;
@synthesize defect = _defect;
@synthesize defectsCount = _defectsCount;
@synthesize purchaseOrderNumber = _purchaseOrderNumber;
@synthesize orderNumber = _orderNumber;
@synthesize pcMfgOrderNum = _pcMfgOrderNum;
@synthesize lineNumber = _lineNumber;
@synthesize quantityShipped = _quantityShipped;
@synthesize submitedByLocationId = _submitedByLocationId;
@synthesize submitedByLocationName = _submitedByLocationName;
@synthesize reportingCustomerId = _reportingCustomerId;
@synthesize reportingCustomerName = _reportingCustomerName;

+ (IPAIQPRecentDefect *) IPAIQPRecentDefectWithDictionary:(NSDictionary *)aDictionary
{
    IPAIQPRecentDefect *i = [[IPAIQPRecentDefect alloc] init];
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"MM/dd/yyyy"];
//    
    i.qualityConcernId = [[aDictionary valueForKey:@"QualityConcernId"] integerValue];
    i.isInternal = [[aDictionary valueForKey:@"IsInternal"] boolValue];
    i.dateEntered = [aDictionary valueForKey:@"DateEntered"];
    i.enteredBy = [aDictionary valueForKey:@"EnteredBy"];
    i.status = [aDictionary valueForKey:@"Status"];
    i.samtecPartMasterDescription = [aDictionary valueForKey:@"Samtec_Part_Master_Description"];
    i.defect = [aDictionary valueForKey:@"Defect"];
    i.defectsCount = [[aDictionary valueForKey:@"DefectsCount"] integerValue];
    i.purchaseOrderNumber = [aDictionary valueForKey:@"Purchase_Order_Number"];
    i.orderNumber = [[aDictionary valueForKey:@"Order_Number"] integerValue];
    i.pcMfgOrderNum = [[aDictionary valueForKey:@"Pc_Mfg_OrderNum"] integerValue];
    i.lineNumber = [[aDictionary valueForKey:@"Line_Number"] integerValue];
    i.quantityShipped = [[aDictionary valueForKey:@"Quantity_Shipped"] integerValue];
    i.submitedByLocationId = [[aDictionary valueForKey:@"SubmitedBy_Location_Id"] integerValue];
    i.submitedByLocationName = [aDictionary valueForKey:@"SubmitedBy_Location_Name"] == [NSNull null] ? @"" : [aDictionary valueForKey:@"SubmitedBy_Location_Name"];
    i.reportingCustomerId = [[aDictionary valueForKey:@"Reporting_Customer_Id"] integerValue];
    i.reportingCustomerName = [aDictionary valueForKey:@"Reporting_Customer_Name"] == [NSNull null] ? @"" : [aDictionary valueForKey:@"Reporting_Customer_Name"];
    
    return i;
}

@end
