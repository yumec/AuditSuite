//
//  Defect.m
//  AuditSuiteApp
//
//  Created by hz-yumec-mac on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Defect.h"

@implementation Defect

@synthesize defectId = _defectId;
@synthesize defectCategoryId = _defectCategoryId;
@synthesize parentDefectCategoryId = _parentDefectCategoryId;
@synthesize description = _description;
@synthesize allDescription = _allDescription;

+ (Defect *) defectWithDictionary:(NSDictionary *)aDictionary
{
    Defect *d = [[Defect alloc] init];
    d.defectId = [[aDictionary valueForKey:@"DefectId"] integerValue];
    d.defectCategoryId = [[aDictionary valueForKey:@"DefectCategoryId"] integerValue];
    d.parentDefectCategoryId = [[aDictionary valueForKey:@"ParentDefectCategoryId"] integerValue];
    d.description = [aDictionary valueForKey:@"Description"];
    d.allDescription = [aDictionary valueForKey:@"AllDescription"];

    return d;
}

@end
