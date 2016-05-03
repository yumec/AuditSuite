//
//  Type.h
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Type : NSObject
{
    NSInteger _typeId;
    //NSObject *_category;
    NSString *_description;
}

@property (nonatomic, assign) NSInteger typeId;
//@property (nonatomic, copy) NSObject *category;
@property (nonatomic, copy) NSString *description;

+ (Type *)typeWithDictionary:(NSDictionary *)aDictionary;

@end
