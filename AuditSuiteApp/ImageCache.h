//
//  ImageCache.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject
{
	NSMutableDictionary *dictionary;
}

+(ImageCache *) sharedImageCache;
-(void) setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *) imageForKey:(NSString *)s;
-(void) deleteImageForKey:(NSString *)s;

@end
