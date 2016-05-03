//
//  IPAPendingOccurrence.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"
#import "Area.h"
#import "Type.h"
#import "Focus.h"
#import "Frequency.h"
#import "User.h"

@interface IPAPendingOccurrence : ModelBase

@property (nonatomic, assign) NSInteger seriesId;
@property (nonatomic, assign) NSInteger occurrenceId;
@property (nonatomic, strong) Area *area;
@property (nonatomic, strong) Type *auditType;
@property (nonatomic, strong) Focus *focus;
@property (nonatomic, strong) Frequency *frequency;
@property (nonatomic, assign) NSInteger occurrenceCount;
@property (nonatomic, strong) NSString *instruction;
@property (nonatomic, strong) NSString *observationValue;
@property (nonatomic, assign) NSInteger numberOfObservations;
@property (nonatomic, strong) NSString  *occurrenceDateStr;
@property (nonatomic, strong) NSDate  *occurrenceDate;
@property (nonatomic, assign) NSInteger numberOfObservationsRemaining;
@property (nonatomic, strong) NSString *pastDueComment;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) User *leadAuditor;


//"SeriesId":4,
//"OccurrenceId":21,
//"Area":{"AreaDescription":"Board Processing","AreaId":4},
//"AuditType":{"TypeDescription":"Area\/Floor","TypeId":3},
//"Focus":{"Area":null,"AuditType":null,"FocusDescription":"Clean and Organized","FocusId":173},
//"Frequency":{"FrequencyDays":1,"FrequencyDescription":"Daily","FrequencyId":1},
//"OccurrenceCount":3,
//"Instruction":"Test Esteban 9",
//"ObservationValue":"Test Esteban 9",
//"NumberOfObservations":3,
//"OccurrenceDate":"\/Date(1323928800000-0500)\/",
//"Status":null
//"NumberOfObservationsRemaining":3,

+ (IPAPendingOccurrence *)iPAPendingOccurrenceWithDictionary:(NSDictionary *)aDictionary;
@end
