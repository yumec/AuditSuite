//
//  IPAOccurrence.m
//  AuditSuite
//
//  Created by Esteban Corrales on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IPAOccurrence.h"

@implementation IPAOccurrence
@synthesize occurrenceId =_occurrenceId;
@synthesize seriesId = _seriesId;
@synthesize occurrenceDate = _occurrenceDate;
@synthesize auditorId = _auditorId;
@synthesize leadAuditorId= _leadAuditorId;
@synthesize isActive = _isActive;
@synthesize enteredBy = _enteredBy;
@synthesize modifiedBy= _modifiedBy;
@synthesize dateEntered = _dateEntered;
@synthesize dateModified = _dateModified;

+ (IPAOccurrence *)ipaOccurrenceWithDictionary:(NSDictionary *)aDictionary
{
    IPAOccurrence *i = [[IPAOccurrence alloc] init];
    
    i.occurrenceId = [[aDictionary valueForKey:@"OccurrenceId"] integerValue];
    i.seriesId = [[aDictionary valueForKey:@"SeriesId"] integerValue];
    i.occurrenceDate = [aDictionary valueForKey:@"OccurrenceDate"];
    i.auditorId = [[aDictionary valueForKey:@"AuditorId"] integerValue];
    i.leadAuditorId = [[aDictionary valueForKey:@"LeadAuditorId"] integerValue];
    i.isActive = [[aDictionary valueForKey:@"IsActive"] boolValue];			
    i.enteredBy = [[aDictionary valueForKey:@"EnteredBy"] integerValue];
    i.modifiedBy = [[aDictionary valueForKey:@"ModifiedBy"] integerValue];
    i.dateEntered = [aDictionary valueForKey:@"DateEntered"];
    i.dateModified= [aDictionary valueForKey:@"DateModified"];
    
    return i;
    
}
@end
