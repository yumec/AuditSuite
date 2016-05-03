//
//  ImageCache.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

static ImageCache *sharedImageCache;

@implementation ImageCache

-(id) init
{
	self = [super init];
	dictionary = [[NSMutableDictionary alloc] init];
	return self;
}


#pragma mark -
#pragma mark Accessing the cache

- (void) setImage:(UIImage *)i forKey:(NSString *)s
{
	[dictionary setObject:i forKey:s];
}

-(UIImage *) imageForKey:(NSString *)s
{
	return [dictionary objectForKey:s];
}

-(void) deleteImageForKey:(NSString *)s
{
	[dictionary removeObjectForKey:s];
}


#pragma mark -
#pragma mark Singleton stuff

+(ImageCache *) sharedImageCache
{
	if (!sharedImageCache) {
		sharedImageCache = [[ImageCache alloc] init];
	}
	
	return sharedImageCache;
}

+ (id) allocWithZone:(NSZone *)zone
{
	if (!sharedImageCache) {
		sharedImageCache = [super allocWithZone:zone];
		return sharedImageCache;
	} else {
		return nil;
	}
}

-(id) copyWithZone:(NSZone *) zone
{
	return self;
}


@end
