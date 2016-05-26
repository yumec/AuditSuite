//
//  AppDelegate.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize currentUser = _currentUser;
@synthesize currentVersion = _currentVersion;
@synthesize currentEnvironment = _currentEnvironment;
@synthesize serverPath = _serverPath;
@synthesize fileManagementServerPath = _fileManagementServerPath;

- (NSString *) documentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    return path;
}

- (User *)currentUser
{
	if (_currentUser == nil)
	{
		NSString *path = [self documentsDirectoryPath];
		NSString *fullPath = [path stringByAppendingPathComponent:@"userinfo.plist"];
		NSDictionary *userinfo = [NSDictionary dictionaryWithContentsOfFile:fullPath];
		
		if (userinfo)
		{
            [self setCurrentUser:[User userWithDictionary:userinfo]];
		}
	}
	return _currentUser;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
//	[self.window addSubview:[[self navigationController] view]];
    self.window.rootViewController = self.navigationController;
	self.serverPath = @"http://productionservice/Samtec.Audit.Service/InProcessAuditService.svc/";
	self.fileManagementServerPath = @"http://productionservice/Samtec.FileManagement.Service/FileManagementRest.svc/";
	
#ifdef IS_DEV
	self.serverPath = @"http://devservice/Samtec.Audit.Service/InProcessAuditService.svc/";	
//    self.serverPath = @"http://hz-yumec.samtec.ad/Samtec.Audit.Service/InProcessAuditService.svc/";
    
    self.fileManagementServerPath = @"http://devservice/Samtec.FileManagement.Service/FileManagementRest.svc/";
//    self.fileManagementServerPath = @"http://hz-yumec.samtec.ad/Samtec.FileManagement.Service/FileManagementRest.svc/";
#endif
		
#ifdef IS_TEST
	self.serverPath = @"http://testservice/Samtec.Audit.Service/InProcessAuditService.svc/";
	self.fileManagementServerPath = @"http://testservice/Samtec.FileManagement.Service/FileManagementRest.svc/";
#endif
    
#ifdef IS_STAG
	self.serverPath = @"http://stageservice/Samtec.Audit.Service/InProcessAuditService.svc/";
	self.fileManagementServerPath = @"http://stageservice/Samtec.FileManagement.Service/FileManagementRest.svc/";
#endif
	
    [self checkForAppUpdate];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self checkForAppUpdate];
}


#pragma mark-
#pragma mark Initial Validation


- (void)checkForAppUpdate
{
#ifdef IS_DEV
	NSString *address = @"https://iosinstallsdev.samtec.com/IOS/AuditSuiteDev.plist";
    self.currentEnvironment = @"Dev";
#endif

#ifdef IS_TEST
    NSString *address = @"https://iosinstallstest.samtec.com/IOS/AuditSuiteTest.plist";
    self.currentEnvironment = @"Test";
#endif

#ifdef IS_STAG
    NSString *address = @"https://iosinstallsstage.samtec.com/IOS/AuditSuiteStag.plist";
    self.currentEnvironment = @"Stage";
#endif   

#ifdef IS_PROD
    NSString *address = @"https://iosinstalls.samtec.com/IOS/AuditSuite.plist";
    self.currentEnvironment = @"Production";
#endif
    
    NSDictionary *plistdict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:address]];
    NSString *serverVersionStr = [[[[plistdict valueForKey:@"items"] valueForKey:@"metadata"] objectAtIndex:0] valueForKey:@"bundle-version"];
    NSString *clientVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    self.currentVersion = [NSString stringWithFormat:@"Current Version: %@", clientVersionStr];
    
    if (clientVersionStr != nil
        && serverVersionStr != nil
        && [clientVersionStr compare:serverVersionStr] != 0)
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Update Available"
                                   message: [NSString stringWithFormat:@"An update (version %@) to Audit Suite is available. Would you like to install?", serverVersionStr]
                                  delegate: self
                         cancelButtonTitle: @"NO"
                         otherButtonTitles: @"YES", nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex 
{
	if (buttonIndex == 1)
	{
		
#ifdef IS_DEV
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://iosinstallsdev.samtec.com/IOS/AuditSuiteDev.plist"]];
		return;
#endif
		
		
#ifdef IS_TEST
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://iosinstallstest.samtec.com/IOS/AuditSuiteTest.plist"]];
		return;
#endif

#ifdef IS_STAG
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://iosinstallsstage.samtec.com/IOS/AuditSuiteStag.plist"]];
		return;
#endif

#ifdef IS_PROD
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://iosinstalls.samtec.com/IOS/AuditSuite.plist"]];
#endif
	}
}

@end
