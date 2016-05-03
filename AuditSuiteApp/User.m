//
//  User.m
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userMasterId = _userMasterId;
@synthesize fullName = _fullName;
@synthesize fullNameCode = _fullNameCode;

-(NSString *)description
{
    return [self fullName];
}

+ (User *)userWithDictionary:(NSDictionary *)aDictionary
{
    User *u = [[User alloc] init];
    
    u.userMasterId = [[aDictionary valueForKey:@"UserMasterId"] integerValue];
    u.fullName = [aDictionary valueForKey:@"FullName"];
    u.fullNameCode = [NSString stringWithFormat:@"%@ - %@", [aDictionary valueForKey:@"UserMasterId"], [aDictionary valueForKey:@"FullName"]];
    
    return u;
}

@end
