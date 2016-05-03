//
//  Area.h
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject
{
    NSInteger _areaId;
    NSString *_description;
}
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, copy) NSString *description;

+ (Area *)areaWithDictionary:(NSDictionary *)aDictionary;

@end
