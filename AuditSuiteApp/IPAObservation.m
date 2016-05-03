//
//  IPAObservation.m
//  AuditSuite
//
//  Created by Esteban Corrales on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IPAObservation.h"

@implementation IPAObservation

@synthesize observationId = _observationId;
@synthesize occurrenceId = _occurrenceId;
@synthesize workCenterId = _workCenterId;
@synthesize auditee = _auditee;
@synthesize supervisor = _supervisor;
@synthesize observationValue = _observationValue;
@synthesize generalNotes = _generalNotes;
@synthesize failType = _failType;
@synthesize notCompleteNotes = _notCompleteNotes;
@synthesize status = _status;
@synthesize enteredBy = _enteredBy;
@synthesize modifiedBy = _modifiedBy;
@synthesize dateEntered = _dateEntered;
@synthesize dateModified = _dateModified;
@synthesize images = _images;
@synthesize qualityConcernId = _qualityConcernId;
@synthesize shiftId = _shiftId;

+ (IPAObservation *)iPAObservationWithDictionary:(NSDictionary *)aDictionary
{
    IPAObservation *i = [[IPAObservation alloc] init];
        
    i.observationId = [[aDictionary valueForKey:@"ObservationId"] integerValue];
    i.occurrenceId = [[aDictionary valueForKey:@"OccurrenceId"] integerValue];
    i.workCenterId = [[aDictionary valueForKey:@"WorkCenterId"] integerValue];
	i.auditee = [User userWithDictionary: [aDictionary valueForKey:@"Auditee"]];
	i.supervisor = [User userWithDictionary: [aDictionary valueForKey:@"Supervisor"]];
    i.observationValue = [aDictionary valueForKey:@"ObservationValue"];
    i.generalNotes = [aDictionary valueForKey:@"GeneralNotes"];
    i.failType = [aDictionary valueForKey:@"FailType"];
    i.notCompleteNotes = [aDictionary valueForKey:@"NotCompleteNotes"];
    i.status = [aDictionary valueForKey:@"Status"];
    i.qualityConcernId = [[aDictionary valueForKey:@"QualityConcernId"] integerValue];
    i.shiftId = [[aDictionary valueForKey:@"ShiftId"] integerValue];
    return i;
}
@end
