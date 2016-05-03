//
//  UIView+Presentation.m
//  SamtecFAETools
//
//  Created by Esteban Torres Hernández on 12/2/10.
//  Copyright 2010 Samtec, Inc. All rights reserved.
//

#import "UIView+Presentation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(Presentation)

- (void) configureViewWithBorderColor:(UIColor *)borderColor BorderWith:(CGFloat)borderWidth CornerRadius:(CGFloat)cornerRadius MaskBounds:(BOOL)maskBounds {
	[self.layer setBorderColor:[borderColor CGColor]];
	[self.layer setBorderWidth:borderWidth];
	[self.layer setCornerRadius:cornerRadius];
	[self.layer setMasksToBounds:maskBounds];
}

- (void) makeCornersRound{
	[self configureViewWithBorderColor:[UIColor lightGrayColor]
							BorderWith:2.00
						  CornerRadius:10.0f
							MaskBounds:YES];
}

- (void) makeShadow
{

    
    // apply the border
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 5.0);
    self.layer.shadowOpacity = 0.5;
    
}

- (UIColor *) colorWithHexString: (NSString *) hex  
{  
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
    
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor grayColor];  
    
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
    
    if ([cString length] != 6) return  [UIColor grayColor];  
    
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
    
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
    
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
    
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
    
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
} 


//Slide the screen down when keyboard hides
- (void)slideDown:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [UIView commitAnimations];
}

//Slide the view up when the keyboard is shown so we dont hide the textfield
- (void)slideUp:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    
        [self setFrame:CGRectMake(0, -216, self.frame.size.width, self.frame.size.height)];
   
    
    [UIView commitAnimations];
}

@end
