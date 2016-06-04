//
//  AppDelegate.h
//  Smart Secure
//
//  Created by Constanza Areco on 07/07/13.
//  Copyright (c) 2013 Smart Secure. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    BOOL pushNotificationReceived;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *pushToken;

@property (strong, nonatomic) ViewController *viewController;

@end
