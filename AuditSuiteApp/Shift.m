//
//  Shift.m
//  AuditSuiteApp
//
//  Created by yumec on 10/14/13.
//
//

#import "Shift.h"

@implementation Shift

@synthesize shiftId = _shiftId;
@synthesize shiftDescription = _shiftDescription;
@synthesize description = _description;

+ (Shift *) shiftWithDictionary:(NSDictionary *)aDictionary
{
    Shift *s = [[Shift alloc] init];
    s.shiftId = [[aDictionary valueForKey:@"ShiftId"] integerValue];
    s.shiftDescription = [aDictionary valueForKey:@"ShiftDescription"];
    s.description = [aDictionary valueForKey:@"ShiftDescription"];
    return s;
}

@end
