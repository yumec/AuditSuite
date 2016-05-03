//
//  IPASeries.h
//  AuditSuite
//
//  Created by Esteban Corrales on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"

@interface IPASerie : ModelBase
{
    NSInteger _seriesId;
    NSInteger _userId;
    NSInteger _areaId;
    NSInteger _typeId;
    NSInteger _focusId;
    NSString *_frequency;
    NSInteger _count;
    NSDate *_startDate;
    NSDate *_dueDate;
    NSString *_instruction;
    NSInteger _numberObservations;
    NSInteger _requestorId;
}

@property (nonatomic, assign) NSInteger seriesId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, assign) NSInteger focusId;
@property (nonatomic, copy) NSString *frequency;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic, copy) NSString *instruction;
@property (nonatomic, assign) NSInteger numberObservations;
@property (nonatomic, assign) NSInteger requestorId;

+ (IPASerie *)ipaSerieWithDictionary:(NSDictionary *)aDictionary;

@end
