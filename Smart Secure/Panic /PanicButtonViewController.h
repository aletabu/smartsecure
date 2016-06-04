//
//  PanicButtonViewController.h
//  Smart Secure
//
//  Created by Constanza Areco on 11/07/13.
//  Copyright (c) 2013 CIDWAY Security. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartSecureViewController.h"

@interface PanicButtonViewController : SmartSecureViewController

@property (strong, nonatomic)  NSTimer *panicTimer;
@property (strong, nonatomic)  NSTimer *timeOutTimer;
@property (strong, nonatomic)  IBOutlet UIImageView *panicGifImage;
@property (strong, nonatomic)  IBOutlet UIImageView *icon;
@property (strong, nonatomic)  IBOutlet UILabel *netTitle;
@property (strong, nonatomic)  IBOutlet UIButton *panicScreenButton;
@property (strong, nonatomic)  IBOutlet UIButton *messagesScreenButton;

@end
