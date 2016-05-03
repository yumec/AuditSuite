//
//  IPAObservationAttachedFile.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IPAObservationAttachedFile.h"
#import "NSData+Base64.h"

@implementation IPAObservationAttachedFile

@synthesize observationAttachedFileId = _observationAttachedFileId;
@synthesize observationId = _observationId;
@synthesize fileType = _fileType;
@synthesize fileData = _fileData;
@synthesize fileNotes = _fileNotes;

+ (IPAObservationAttachedFile *)iPAObservationAttachedFileWithDictionary:(NSDictionary *)aDictionary
{
	IPAObservationAttachedFile *i = [[IPAObservationAttachedFile alloc] init];
	
	i.observationAttachedFileId	= [[aDictionary valueForKey:@"ObservationAttachedFileId"] integerValue];
	i.observationId	= [[aDictionary valueForKey:@"ObservationId"] integerValue];
	i.fileType	= [aDictionary valueForKey:@"FileType"];
	//i.fileData	= [UIImage imageWithData: [NSData dataWithBase64EncodedString:[aDictionary valueForKey:@"FileData"]]];
	i.fileData = [UIImage imageWithContentsOfFile:[aDictionary valueForKey:@"FileData"]];
	i.fileNotes	= [aDictionary valueForKey:@"FileNotes"];
	
	return i;
}

@end
