//
//  Area.m
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Area.h"

@implementation Area

@synthesize areaId = _areaId;
@synthesize description = _description;

+ (Area *)areaWithDictionary:(NSDictionary *)aDictionary
{
    Area *i = [[Area alloc] init];
    
    i.areaId = [[aDictionary valueForKey:@"AreaId"] integerValue];
    i.description = [aDictionary valueForKey:@"AreaDescription"];
    
    return i;
    
}
@end
