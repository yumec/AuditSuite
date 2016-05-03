//
//  Focus.m
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Focus.h"

@implementation Focus

@synthesize focusId = _focusId;
//@synthesize areaId = _areaId;
//@synthesize typeId = _typeId;
@synthesize description = _description;

+ (Focus *)focusWithDictionary:(NSDictionary *)aDictionary
{
    Focus *i = [[Focus alloc] init];
    
    i.focusId = [[aDictionary valueForKey:@"FocusId"] integerValue];
//    i.areaId = [[aDictionary valueForKey:@"areaId"] integerValue];
//    i.typeId = [[aDictionary valueForKey:@"typeId"] integerValue];
    i.description = [aDictionary valueForKey:@"FocusDescription"];
    
    return i;
    
}

@end
