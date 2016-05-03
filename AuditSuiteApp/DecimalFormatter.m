//
//  DecimalFormatter.m
//  SamtecFAETools
//
//  Created by Craig Kennedy on 1/27/11.
//  Copyright 2011 Samtec, Inc. All rights reserved.
//

#import "DecimalFormatter.h"


@implementation DecimalFormatter

+ (NSNumberFormatter *)decimalFormatterWithNumberOfDecimals:(NSInteger)numberOfDecimals
{
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    frm.numberStyle = NSNumberFormatterDecimalStyle;
    [frm setMaximumFractionDigits:numberOfDecimals];
    [frm setMinimumFractionDigits:numberOfDecimals];
    
    return frm;
}

@end
