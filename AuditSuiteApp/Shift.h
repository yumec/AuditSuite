//
//  Shift.h
//  AuditSuiteApp
//
//  Created by yumec on 10/14/13.
//
//

#import <Foundation/Foundation.h>

@interface Shift : NSObject
{
    NSInteger _shiftId;
    NSString *_shiftDescription;
    NSString *_description;
}

@property (nonatomic, assign) NSInteger shiftId;
@property (nonatomic, copy) NSString *shiftDescription;
@property (nonatomic, copy) NSString *description;

+ (Shift *)shiftWithDictionary:(NSDictionary *)aDictionary;

@end
