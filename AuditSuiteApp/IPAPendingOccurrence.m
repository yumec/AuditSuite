//
//  IPAPendingOccurrence.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IPAPendingOccurrence.h"

@implementation IPAPendingOccurrence

@synthesize seriesId = _seriesId;
@synthesize occurrenceId = _occurrenceId;
@synthesize area = _area;
@synthesize auditType = _auditType;
@synthesize focus = _focus;
@synthesize frequency = _frequency;
@synthesize occurrenceCount = _occurrenceCount;
@synthesize instruction = _instruction;
@synthesize observationValue = _observationValue;
@synthesize numberOfObservations = _numberOfObservations;
@synthesize occurrenceDateStr = _occurrenceDateStr;
@synthesize occurrenceDate = _occurrenceDate;
@synthesize numberOfObservationsRemaining = _numberOfObservationsRemaining;
@synthesize pastDueComment = _pastDueComment;
@synthesize active = _active;
@synthesize leadAuditor = _leadAuditor;

+ (IPAPendingOccurrence *)iPAPendingOccurrenceWithDictionary:(NSDictionary *)aDictionary
{
    IPAPendingOccurrence *i = [[IPAPendingOccurrence alloc] init];
    
    NSDateFormatter *od = [[NSDateFormatter alloc] init];
	[od setDateFormat:@"MM/dd/yyyy"];

    i.seriesId = [[aDictionary valueForKey:@"SeriesId"] integerValue];
    i.occurrenceId = [[aDictionary valueForKey:@"OccurrenceId"] integerValue];
    i.area = [Area areaWithDictionary: [aDictionary valueForKey:@"Area"]];
    i.auditType = [Type typeWithDictionary: [aDictionary valueForKey:@"AuditType"]];
    i.focus = [Focus focusWithDictionary: [aDictionary valueForKey:@"Focus"]];
    i.frequency = [Frequency frequencyWithDictionary: [aDictionary valueForKey:@"Frequency"]];
    i.occurrenceCount = [[aDictionary valueForKey:@"OccurrenceCount"] integerValue];
    i.instruction = [aDictionary valueForKey:@"Instruction"];
    i.observationValue = [aDictionary valueForKey:@"ObservationValue"];
    i.numberOfObservations = [[aDictionary valueForKey:@"NumberOfObservations"] integerValue];
    i.numberOfObservationsRemaining = [[aDictionary valueForKey:@"NumberOfObservationsRemaining"] integerValue];
    i.occurrenceDateStr = [aDictionary valueForKey:@"OccurrenceDate"];
    i.occurrenceDate = [od dateFromString:[aDictionary valueForKey:@"OccurrenceDate"]];
	i.pastDueComment = [aDictionary valueForKey:@"PastDueComment"] == [NSNull null] ? @"" : [aDictionary valueForKey:@"PastDueComment"];
	i.active = [[aDictionary valueForKey:@"Active"] boolValue];
	i.leadAuditor = [User userWithDictionary:[aDictionary valueForKey:@"LeadAuditor"]];
	
    return i;
}
@end
