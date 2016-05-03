//
//  WorkCenter.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkCenter.h"

@implementation WorkCenter

@synthesize workCenterId = _workCenterId;
@synthesize description = _description;
@synthesize workCenterCode = _workCenterCode;
@synthesize workCenterCodeDescription = _workCenterCodeDescription;

+ (WorkCenter *)workCenterWithDictionary:(NSDictionary *)aDictionary
{
    WorkCenter *i = [[WorkCenter alloc] init];
    
    i.workCenterId = [[aDictionary valueForKey:@"WorkCenterId"] integerValue];
    i.description = [aDictionary valueForKey:@"WorkCenterDescription"];
    i.workCenterCode = [aDictionary valueForKey:@"WorkCenter"];
    i.workCenterCodeDescription =[NSString stringWithFormat:@"%@ - %@", [aDictionary valueForKey:@"WorkCenter"], [aDictionary valueForKey:@"WorkCenterDescription"]];
	
    return i;
    
}

@end
