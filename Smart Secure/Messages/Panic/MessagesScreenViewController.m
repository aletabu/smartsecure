//
//  MessagesScreenViewController.m
//  Smart Secure
//
//  Created by Constanza Areco on 12/07/13.
//  Copyright (c) 2013 CIDWAY Security. All rights reserved.
//

#import "MessagesScreenViewController.h"
#import "AppDelegate.h"
#import "PanicButtonViewController.h"
#import "ConfigurationData.h"
#import "ViewController.h"
#import "KeyChainHelper.h"

#define kStackSpacing 6

@interface MessagesScreenViewController ()

@end

@implementation MessagesScreenViewController

@synthesize sendButton, redTitle, specificationsTitle, messageTextField, scrollView, panicScreenButton;

- (void) loadSendButton {
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[sendButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [sendButton setTitle:NSLocalizedString(@"Send", @"") forState:UIControlStateNormal];
}

- (void) addButton : (NSString *) buttonText : (int) position {
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:buttonText forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(3, position * 49, 277, 44)];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[btn1 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(messageSelected:) forControlEvents:UIControlEventTouchUpInside];

    [scrollView addSubview:btn1];


}

- (void) loadMessagesButtons {

    NSMutableArray * messages = [[NSMutableArray alloc] init];
    KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
    
    NSDictionary * networks = [self.superViewController getUserNetworks];

    for (NSDictionary * network in networks) {
        if ([[network objectForKey:@"id"] isEqualToString:[[[keyChainHelper loadSelectedNetwork]propertyList] objectForKey:@"id"]]) {
            NSArray * templates = [network objectForKey:@"templates"];
            
            for (NSDictionary * template in templates) {
                [messages addObjectsFromArray:[template objectForKey:@"messages"]];
            }
            break;
        }
    }
    
    int i = 0;
    for (NSString * message in messages) {
        [self addButton:message :i];
        i++;
    }

    scrollView.contentSize = CGSizeMake(283,50*10);


}

- (IBAction)messageSelected:(id)sender {
    UIButton *button = sender;
    
    NSString *message = button.titleLabel.text;
    [self sendMessage : message];
}

- (void) sendMessage : (NSString *) msg {
    [self.serverRequestController sendMessage:msg];

}


- (void) showAlert : (NSString *) title : (NSString *) msg {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)send:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self.messageTextField.text length] == 0) {
        [self showAlert:NSLocalizedString(@"Error", @"") : NSLocalizedString(@"MessageEmptyError", @"")];
    } else {
        [self sendMessage:self.messageTextField.text];
    }

}

- (void) setColors {
 ;
    [self.messageTextField setTextColor:[UIColor colorWithRed:54/255.0 green:153/255.0 blue:127/255.0 alpha:1.0f]];
    [self.sendMessageBackground setBackgroundColor:[UIColor colorWithRed:28/255.0 green:79/255.0 blue:65/255.0 alpha:1.0f]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    KeyChainHelper * keyChain = [[KeyChainHelper alloc] init];
    
    [self.redTitle setMinimumFontSize:11.0];

    self.redTitle.text = [[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"name"];
    [self setColors];
    self.specificationsTitle.text = NSLocalizedString(@"Specifications", @"");
    self.messageTextField.placeholder = NSLocalizedString(@"EnterMessageText", @"");
    [self loadSendButton];
    [self loadMessagesButtons];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)evt
{
    [self dismissKeyboard:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 205; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 150 && range.length == 0)
    {
    	return NO; // return NO to not change text
    }
    else
    {return YES;}
}

- (IBAction) shoPanicButtonScreen : (id)sender {
    [self.superViewController loadPanicButtonScreen];
}

@end
