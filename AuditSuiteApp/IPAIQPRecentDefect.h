//
//  IPAIQPRecentDefect.h
//  AuditSuiteApp
//
//  Created by hz-yumec on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAIQPRecentDefect : NSObject
{
    NSInteger _qualityConcernId;
    BOOL _isInternal;
    NSString *_dateEntered;
    NSString *_enteredBy;
    NSString *_status;
    NSString *_samtecPartMasterDescription;
    NSString *_defect;
    NSInteger _defectsCount;
    NSString *_purchaseOrderNumber;
    NSInteger _orderNumber;
    NSInteger _pcMfgOrderNum;
    NSInteger _lineNumber;
    NSInteger _quantityShipped;
    NSInteger _submitedByLocationId;
    NSString *_submitedByLocationName;
    NSInteger _reportingCustomerId;
    NSString *_reportingCustomerName;
}

@property (nonatomic, assign) NSInteger qualityConcernId;
@property (nonatomic, assign) BOOL isInternal;
@property (nonatomic, strong) NSString *dateEntered;
@property (nonatomic, strong) NSString *enteredBy;
@property (nonatomic, strong) NSString  *status;
@property (nonatomic, strong) NSString  *samtecPartMasterDescription;
@property (nonatomic, strong) NSString  *defect;
@property (nonatomic, assign) NSInteger defectsCount;
@property (nonatomic, strong) NSString  *purchaseOrderNumber;
@property (nonatomic, assign) NSInteger orderNumber;
@property (nonatomic, assign) NSInteger pcMfgOrderNum;
@property (nonatomic, assign) NSInteger lineNumber;
@property (nonatomic, assign) NSInteger quantityShipped;
@property (nonatomic, assign) NSInteger submitedByLocationId;
@property (nonatomic, strong) NSString  *submitedByLocationName;
@property (nonatomic, assign) NSInteger reportingCustomerId;
@property (nonatomic, strong) NSString  *reportingCustomerName;

+ (IPAIQPRecentDefect *) IPAIQPRecentDefectWithDictionary:(NSDictionary *)aDictionary;

@end
