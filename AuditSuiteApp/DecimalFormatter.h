//
//  DecimalFormatter.h
//  SamtecFAETools
//
//  Created by Craig Kennedy on 1/27/11.
//  Copyright 2011 Samtec, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DecimalFormatter : NSNumberFormatter
{
@private
    
}

+ (NSNumberFormatter *)decimalFormatterWithNumberOfDecimals:(NSInteger)numberOfDecimals;

@end
