//
//  ActivityAlertView.h
//  AuditSuiteApp
//
//  Created by Esteban Torres Hernández on 11/25/10.
//  Copyright 2010 Samtec, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityAlertView : UIAlertView {
	UIActivityIndicatorView *loader;
}

- (id) initWithMessage:(NSString *)message;
- (void) close;

@end
