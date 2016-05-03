//
//  Frequency.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Frequency : NSObject
{
    NSInteger _frequencyId;
    NSString *_description;
    NSInteger _frequencyDays;
}
@property (nonatomic, assign) NSInteger frequencyId;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSInteger frequencyDays; 

+ (Frequency *)frequencyWithDictionary:(NSDictionary *)aDictionary;
@end
