//
//  ModelBase.m
//  FAE Tools
//
//  Created by Craig Kennedy on 11/18/10.
//  Copyright 2010 Samtec, Inc. All rights reserved.
//

#import "ModelBase.h"


@implementation ModelBase

+ (id)objectWithDictionary:(NSDictionary *)aDictionary
{
	return [[self alloc] initWithDictionary:aDictionary];
}

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
	self = [super init];
	[self setValuesForKeysWithDictionary:aDictionary];
	return self;
}

@end
