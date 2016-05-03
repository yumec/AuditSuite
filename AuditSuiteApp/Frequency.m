//
//  Frequency.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Frequency.h"

@implementation Frequency

@synthesize frequencyId = _frequencyId;
@synthesize description = _description;
@synthesize frequencyDays = _frequencyDays;

+ (Frequency *)frequencyWithDictionary:(NSDictionary *)aDictionary
{
    Frequency *i = [[Frequency alloc] init];
    
    i.frequencyId = [[aDictionary valueForKey:@"FrequencyId"] integerValue];
    i.description = [aDictionary valueForKey:@"FrequencyDescription"];
    i.frequencyDays =  [[aDictionary valueForKey:@"FrequencyDays"] integerValue];
    
    return i;
    
}
@end
