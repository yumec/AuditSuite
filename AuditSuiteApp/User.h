//
//  User.h
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@interface User : ModelBase
{
    NSInteger _userMasterId;
    NSString *_fullName;
    NSString *_fullNameCode;
}

@property (nonatomic, assign) NSInteger userMasterId;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *fullNameCode;


+ (User *)userWithDictionary:(NSDictionary *)aDictionary;
@end
