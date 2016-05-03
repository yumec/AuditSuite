//
//  Type.m
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Type.h"

@implementation Type

@synthesize typeId = _typeId;
//@synthesize category = _category;
@synthesize description = _description;

+ (Type *)typeWithDictionary:(NSDictionary *)aDictionary
{
    Type *i = [[Type alloc] init];
    
    i.typeId = [[aDictionary valueForKey:@"TypeId"] integerValue];
    //i.category = [aDictionary valueForKey:@"category"];
    i.description = [aDictionary valueForKey:@"TypeDescription"];
    
    return i;
    
}
@end
