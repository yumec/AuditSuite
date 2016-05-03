//
//  Focus.h
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Area;
@class Type;

@interface Focus : NSObject
{
    NSInteger _focusId;
//    NSInteger _areaId;
//    NSInteger _typeId;
    NSString *_description;
}

@property (nonatomic, assign) NSInteger focusId;
//@property (nonatomic, assign) NSInteger areaId;
//@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *description;

+ (Focus *)focusWithDictionary:(NSDictionary *)aDictionary;
@end
