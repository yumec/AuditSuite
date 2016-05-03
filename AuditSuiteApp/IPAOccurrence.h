//
//  IPAOccurrence.h
//  AuditSuite
//
//  Created by Esteban Corrales on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@interface IPAOccurrence : ModelBase

{
    NSInteger _occurrenceId;
    NSInteger _seriesId;
    NSDate *_occurrenceDate;
    NSInteger _auditorId;
    NSInteger _leadAuditorId;
    BOOL _isActive;
    NSInteger _enteredBy;
    NSInteger _modifiedBy;
    NSDate *_dateEntered;
    NSDate *_dateModified;
}

@property (nonatomic, assign) NSInteger occurrenceId;
@property (nonatomic, assign) NSInteger seriesId;
@property (nonatomic, copy) NSDate *occurrenceDate;
@property (nonatomic, assign) NSInteger auditorId;
@property (nonatomic, assign) NSInteger leadAuditorId;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) NSInteger enteredBy;
@property (nonatomic, assign) NSInteger modifiedBy;
@property (nonatomic, copy) NSDate *dateEntered;
@property (nonatomic, copy) NSDate *dateModified;

+ (IPAOccurrence *)ipaOccurrenceWithDictionary:(NSDictionary *)aDictionary;

@end
