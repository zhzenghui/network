//
//  ZHAppDelegate.m
//  NetWork
//
//  Created by mbp  on 13-7-31.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHAppDelegate.h"

#import "ZHViewController.h"
#import "TopIOSClient.h"
#import "TopAppConnector.h"


@implementation ZHAppDelegate


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    TopAppConnector *appConnector = [TopAppConnector getAppConnectorbyAppKey:KTaoBaoAppKey];
    
    [appConnector receiveMessageFromApp:[url absoluteString]];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url
{
    
    TopIOSClient *topIOSClient = [TopIOSClient registerIOSClient:KTaoBaoAppKey appSecret:KTaoBaoSecert callbackUrl:KTaoBaoCallbackUrl needAutoRefreshToken:TRUE];
    
    [TopAppConnector registerAppConnector:KTaoBaoAppKey topclient:topIOSClient];
    

    return YES;
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    self.viewController = [[[ZHViewController alloc] initWithNibName:@"ZHViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
