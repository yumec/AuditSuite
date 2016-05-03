//
//  WorkCenter.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkCenter : NSObject
{
    NSInteger _workCenterId;
	NSString *_workCenterCode;
    NSString *_description;
	NSString *_workCenterCodeDescription;
}
@property (nonatomic, assign) NSInteger workCenterId;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *workCenterCode;
@property (nonatomic, copy) NSString *workCenterCodeDescription;

+ (WorkCenter *)workCenterWithDictionary:(NSDictionary *)aDictionary;

@end
