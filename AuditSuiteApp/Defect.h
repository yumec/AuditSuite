//
//  Defect.h
//  AuditSuiteApp
//
//  Created by hz-yumec-mac on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Defect : NSObject
{
    NSInteger _defectId;
    NSInteger _defectCategoryId;
    NSInteger _parentDefectCategoryId;
    NSString *_description;
    NSString *_allDescription;
}

@property (nonatomic, assign) NSInteger defectId;
@property (nonatomic, assign) NSInteger defectCategoryId;
@property (nonatomic, assign) NSInteger parentDefectCategoryId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *allDescription;

+ (Defect *) defectWithDictionary:(NSDictionary *)aDictionary;

@end
