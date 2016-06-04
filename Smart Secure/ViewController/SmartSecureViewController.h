//
//  SmartSecureViewController.h
//  Smart Secure
//
//  Created by Constanza Areco on 16/07/13.
//  Copyright (c) 2013 CIDWAY Security. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class ServerRequestController;

@interface SmartSecureViewController : UIViewController

@property (strong, nonatomic)  ViewController *superViewController;
@property (strong, nonatomic)  ServerRequestController *serverRequestController;

- (void) requestFailed;
@end
