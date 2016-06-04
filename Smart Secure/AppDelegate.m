//
//  AppDelegate.m
//  Smart Secure
//
//  Created by Constanza Areco on 07/07/13.
//  Copyright (c) 2013 Smart Secure. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate
@synthesize pushToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    // Register this app, on this device
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNone)];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) purgePushToken : (NSString *) token {
    
    if (([token characterAtIndex:0] == '<')
        && ([token characterAtIndex: ([token length] - 1)] == '>'))
    {
        pushToken = [token substringWithRange: NSMakeRange(1, [token length] - 2)];
    } else {
        pushToken = token;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self purgePushToken: [NSString stringWithFormat:@"%@", deviceToken]];

    [self.viewController updatePushNotificationsId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    if ((state == UIApplicationStateActive)
            && self.viewController)
    {
        // event_id(long) smart_message_type SYNC_EVENTS (string) network_id (int)
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.viewController updateEventMessages];
    }
    
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
    // TODO Manage refresh when app is back from background.
    // Chequear que tipo de notificación es y llamar al refresh correspondiente.
    
    if (self.viewController)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.viewController updateEventMessages];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
