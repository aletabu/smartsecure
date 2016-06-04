//
//  MessagesScreenViewController.h
//  Smart Secure
//
//  Created by Constanza Areco on 12/07/13.
//  Copyright (c) 2013 CIDWAY Security. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartSecureViewController.h"

@interface MessagesScreenViewController : SmartSecureViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *redTitle;
@property (strong, nonatomic) IBOutlet UILabel *specificationsTitle;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *sendMessageBackground;
@property (strong, nonatomic)  IBOutlet UIButton *panicScreenButton;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@end
