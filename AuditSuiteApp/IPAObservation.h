//
//  IPAObservation.h
//  AuditSuite
//
//  Created by Esteban Corrales on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"
#import "User.h"

@interface IPAObservation : ModelBase
{
    NSInteger _observationId;
    NSInteger _occurrenceId;
	NSInteger _workCenterId;
	User *_auditee;
	User *_supervisor;
    NSString *_observationValue;
	NSString *_generalNotes;
	NSString *_failType;
	NSString *_notCompleteNotes;
    NSString *_status;
	User *_enteredBy;
	User *_modifiedBy;
	NSDate *_dateEntered;
	NSDate *_dateModified;
	NSMutableArray *_images;
	NSInteger _qualityConcernId;
    NSInteger _shiftId;
//	FullName
//	UserMasterId
}

@property (nonatomic, assign) NSInteger observationId;
@property (nonatomic, assign) NSInteger occurrenceId;
@property (nonatomic, assign) NSInteger workCenterId;
@property (nonatomic, strong) User *auditee;
@property (nonatomic, strong) User *supervisor;
@property (nonatomic, strong) NSString *observationValue;
@property (nonatomic, strong) NSString *generalNotes;
@property (nonatomic, strong) NSString *failType;
@property (nonatomic, strong) NSString *notCompleteNotes;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) User *enteredBy;
@property (nonatomic, strong) User *modifiedBy;
@property (nonatomic, strong) NSDate *dateEntered;
@property (nonatomic, strong) NSDate *dateModified;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) NSInteger qualityConcernId;
@property (nonatomic, assign) NSInteger shiftId;

+ (IPAObservation *)iPAObservationWithDictionary:(NSDictionary *)aDictionary;

@end
