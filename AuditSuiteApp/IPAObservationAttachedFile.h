//
//  IPAObservationAttachedFile.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelBase.h"
#import "User.h"

@interface IPAObservationAttachedFile : ModelBase
{
	NSInteger _observationAttachedFileId;
    NSInteger _observationId;
    NSString *_fileType;
	UIImage *_fielData;
	NSString *_fileNotes;
}

@property (nonatomic, assign) NSInteger observationAttachedFileId;
@property (nonatomic, assign) NSInteger observationId;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) UIImage *fileData;
@property (nonatomic, strong) NSString *fileNotes;

+ (IPAObservationAttachedFile *)iPAObservationAttachedFileWithDictionary:(NSDictionary *)aDictionary;

@end
