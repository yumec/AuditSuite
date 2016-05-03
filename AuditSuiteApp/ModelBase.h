//
//  ModelBase.h
//  FAE Tools
//
//  Created by Craig Kennedy on 11/18/10.
//  Copyright 2010 Samtec, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelBase : NSObject {

}

+ (id)objectWithDictionary:(NSDictionary *)aDictionary;
- (id)initWithDictionary:(NSDictionary *)aDictionary;


@end
