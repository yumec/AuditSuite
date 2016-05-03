//
//  IPASeries.m
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IPASerie.h"

@implementation IPASerie

@synthesize seriesId = _seriesId;
@synthesize userId = _userId;
@synthesize areaId = _areaId;
@synthesize typeId = _typeId;
@synthesize focusId = _focusId;
@synthesize frequency = _frequency;
@synthesize count = _count;
@synthesize startDate = _startDate;
@synthesize dueDate = _dueDate;
@synthesize instruction = _instruction;
@synthesize numberObservations = _numberObservations;
@synthesize requestorId = _requestoriD;

+ (IPASerie *)ipaSerieWithDictionary:(NSDictionary *)aDictionary
{
    IPASerie *i = [[IPASerie alloc] init];
    
    NSDateFormatter *sd = [[NSDateFormatter alloc] init];
	[sd setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *dd = [[NSDateFormatter alloc] init];
	[dd setDateFormat:@"MM/dd/yyyy"];
    
    i.seriesId = [[aDictionary valueForKey:@"SeriesId"] integerValue];
    i.userId = [[aDictionary valueForKey:@"UserId"] integerValue];
    i.areaId = [[aDictionary valueForKey:@""] integerValue];
    i.typeId = [[aDictionary valueForKey:@""] integerValue];
    i.focusId = [[aDictionary valueForKey:@""] integerValue];
    i.frequency = [aDictionary valueForKey:@"Frequency"];
    i.count = [[aDictionary valueForKey:@"Count"] integerValue];
    i.startDate = [sd dateFromString:[aDictionary valueForKey:@"StartDate"]];				
    i.dueDate = [dd dateFromString: [aDictionary valueForKey:@"DueDate"]];
    i.instruction = [aDictionary valueForKey:@"Instruction"];
    i.numberObservations = [[aDictionary valueForKey:@"NumberObservations"] integerValue];
    i.requestorId = [[aDictionary valueForKey:@"Requestor"] integerValue];
    
    return i;
    
}

@end
