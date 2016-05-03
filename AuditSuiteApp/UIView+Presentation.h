//
//  UIView+Presentation.h
//  SamtecFAETools
//
//  Created by Esteban Torres Hernández on 12/2/10.
//  Copyright 2010 Samtec, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Presentation)

- (void) configureViewWithBorderColor:(UIColor *)borderColor BorderWith:(CGFloat)borderWidth CornerRadius:(CGFloat)cornerRadius MaskBounds:(BOOL)maskBounds;
- (void) makeCornersRound;
- (void) makeShadow;
- (UIColor *) colorWithHexString: (NSString *) hex;
- (void)slideDown:(id)sender;
- (void)slideUp:(id)sender;
@end
