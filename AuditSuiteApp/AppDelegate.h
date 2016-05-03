//
//  AppDelegate.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
@class User;

@interface AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) NSString *currentEnvironment;
@property (nonatomic, strong) NSString *serverPath;
@property (nonatomic, strong) NSString *fileManagementServerPath;

- (void)checkForAppUpdate;
- (NSString *) documentsDirectoryPath;

@end
