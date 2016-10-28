//
//  ModeratorMessagesViewController.m
//  Smart Secure
//
//  Created by Constanza Areco on 01/12/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "ModeratorMessagesViewController.h"
#import "ViewController.h"
#import "KeyChainHelper.h"
#import "MessageView.h"

@interface ModeratorMessagesViewController ()

@end

@implementation ModeratorMessagesViewController
@synthesize redTitle, messageTextField, sendButton, scrollView, incidentText, incidentTitle, startTimeText, startTimeTitle, stateText, stateTitle, arrowLeftButton, arrowrightButton, model, networkId, eventList, noEventsLabel, currentEventView, sendMessageBackground;

- (void) loadSendButton {
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[sendButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [sendButton setTitle:NSLocalizedString(@"Send", @"") forState:UIControlStateNormal];
}

- (void) updateInfo : (NSDictionary *) eventsInfo {
    self.model = eventsInfo;
    
    [self loadInfo];
}

- (void) setEventPosition : (int) position{
    eventPosition = position;
}


- (void) setEventsModelFromKeyChain : (KeyChainHelper *) keyChain {
    
    NSString * eventsInfo = [keyChain loadEventsInfoForNetwork:self.networkId];
    
    if (eventsInfo) {
        self.model = [eventsInfo propertyList];
    }
    
    [self loadInfo];

}

- (void) setDate : (NSString *) startDate {
   
    
    NSArray *startDateArray = [startDate componentsSeparatedByString:@"T"];
    NSArray *date = [[startDateArray objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *hour = [[startDateArray objectAtIndex:1] componentsSeparatedByString:@":"];

    
    self.startTimeText.text = [NSString stringWithFormat:@"%@/%@/%@  %@:%@", [date objectAtIndex:2], [date objectAtIndex:1], [date objectAtIndex:0], [hour objectAtIndex:0], [hour objectAtIndex:1]];

}

- (void) hideMessageComponent {
    
    [self.messageTextField setHidden:YES];
    [self.sendButton setHidden:YES];
    [self.sendMessageBackground setHidden:YES];
    
}

- (void) showMessageComponent {
    
    [self.messageTextField setHidden:NO];
    [self.sendButton setHidden:NO];
    [self.sendMessageBackground setHidden:NO];

}

- (void) updateSendMessageComponentsState : (NSDictionary *) event{
    
    if ([[event objectForKey:@"status"] isEqualToString:@"RESOLVED"]) {
        [self hideMessageComponent];
    } else {
        [self showMessageComponent];
    }
}

- (void) updateEventState : (NSDictionary *) event{
    
    if ([[event objectForKey:@"status"] isEqualToString:@"RESOLVED"]) {
        self.stateText.text = NSLocalizedString(@"ResolvedState", @"");
    } else {
        self.stateText.text = NSLocalizedString(@"ActiveState", @"");
    }
}

- (void) selectEventById : (NSString *) eventId {
    int i= 0;
    
    for (NSDictionary * event in self.eventList) {
        if ([[event objectForKey:@"id"] isEqualToString:eventId]) {
            [self selectEvent:i];
            break;
        }
        i++;
    }
}

- (void) selectEvent : (int) eventPos {
    
    eventPosition = eventPos;
    
    NSDictionary * event = [self.eventList objectAtIndex:eventPosition];
    
    [self updateSendMessageComponentsState : event];
    [self updateEventState:event];
    NSString * cause = [event objectForKey:@"cause"];
    self.incidentText.text = cause==nil? @"Sin causa" : cause;
    [self setDate:[event objectForKey:@"start"]];
    [self updateMessagesForCurrentEvent];

}

- (void) showScrollView : (BOOL) show {
    
    if (show) {
        [self.scrollView setHidden:NO];
        [self.currentEventView setHidden:NO];
        [self.sendMessageBackground setHidden:NO];
        [self.sendButton setHidden:NO];
        [self.messageTextField setHidden:NO];
        [self.noEventsLabel setHidden:YES];
    } else {
        [self.scrollView setHidden:YES];
        [self.currentEventView setHidden:YES];
        [self.sendMessageBackground setHidden:YES];
        [self.sendButton setHidden:YES];
        [self.messageTextField setHidden:YES];

        [self.noEventsLabel setHidden:NO];
    }
}

- (void) updateArrowsState {
    
    if ([[self.model objectForKey:@"count"] integerValue] == 1) {
        [self.arrowLeftButton setHidden:YES];
        [self.arrowrightButton setHidden:YES];
    } else {
        [self.arrowLeftButton setHidden:NO];
        [self.arrowrightButton setHidden:NO];
    }

}

- (void) updateEventList {
    [self.eventList removeAllObjects];
    
    if ([[self.model objectForKey:@"count"] integerValue] > 0) {
        
        [self showScrollView:YES];
        [self updateArrowsState];
        
        for (NSDictionary * event in [self.model objectForKey:@"results"]) {
            [self.eventList  addObject:event];
        }
        
        [self selectEvent:eventPosition];
    } else {
        [self showScrollView:NO];
    }
}

- (void) updateMessagesForCurrentEvent {
    int contactWidth = 0;
    int contactHeight = 0;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSDictionary * currentEvent = [self.eventList objectAtIndex:eventPosition];
    
    self.redTitle.text = [currentEvent objectForKey:@"network_name"];

    
    NSDictionary * messages = [currentEvent objectForKey:@"messages"];
    
    for (NSDictionary * messageModel in messages) {
        MessageView *message = [[NSBundle mainBundle]
                                loadNibNamed:@"MessageView"
                                owner:self options:nil].lastObject;
        
        [message setModel:messageModel];
        
        CGRect frame = message.frame;
        contactWidth = frame.size.width;
        frame.origin.x = 0;
        frame.origin.y = contactHeight;
        contactHeight = contactHeight + frame.size.height;

        message.frame = frame;
        
        
        [self.scrollView addSubview:message];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(contactWidth, contactHeight);
    
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom);
    [self.scrollView setContentOffset:bottomOffset animated:NO];
}

- (void) loadInfo {
    [self updateEventList];
}

- (IBAction) previousIncident :(id)sender {
    
    if (eventPosition == 0) {
        [ self selectEvent: ([[self.model objectForKey:@"count"] integerValue] - 1)];
    } else {
        [ self selectEvent: (eventPosition - 1)];
    }
}

- (IBAction) nextIncident :(id)sender {
    if (eventPosition == ([[self.model objectForKey:@"count"] integerValue] - 1)) {
        [ self selectEvent: 0];
    } else {
        [ self selectEvent: (eventPosition + 1)];
    }
}

- (NSString *) getEventId {
    NSString *eventId;
    NSDictionary * event = [self.eventList objectAtIndex:eventPosition];
    if (event) {
        eventId = [event objectForKey:@"id"];
    }
    return eventId;
}

- (void) sendMessage : (NSString *) msg {
    [self.serverRequestController sendIncidentMessage: msg : [self getEventId] : eventPosition : self.superViewController];
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

- (void) getInfoFromServer {
    
    [self.serverRequestController getIncidentsInfoForNetwork:self.networkId :self.superViewController];
}

- (void) setColors {
    [currentEventView setBackgroundColor:[UIColor colorWithRed:54/255.0 green:153/255.0 blue:127/255.0 alpha:1.0f]];
    [self.messageTextField setTextColor:[UIColor colorWithRed:54/255.0 green:153/255.0 blue:127/255.0 alpha:1.0f]];
    [self.sendMessageBackground setBackgroundColor:[UIColor colorWithRed:28/255.0 green:79/255.0 blue:65/255.0 alpha:1.0f]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KeyChainHelper * keyChain = [[KeyChainHelper alloc] init];
    [self.redTitle setMinimumFontSize:11.0];

    self.redTitle.text = [[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"name"];
    self.networkId = [[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"id"];
    
    [self getInfoFromServer];
    
    [self setColors];
    
    self.incidentTitle.text = NSLocalizedString(@"IncidentTitle", @"");
    self.startTimeTitle.text = NSLocalizedString(@"StartTitle", @"");
    self.stateTitle.text = NSLocalizedString(@"StateTitle", @"");
    self.noEventsLabel.text = NSLocalizedString(@"NoEventMessagesText", @"");

    self.messageTextField.placeholder = NSLocalizedString(@"EnterMessageText", @"");
    [self loadSendButton];
    self.eventList = [[NSMutableArray alloc] init];
    [self setEventsModelFromKeyChain : keyChain];
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

- (IBAction) chooseNetwork : (id)sender {
    [self.superViewController loadChooseNetScreen : @"MESSAGEMODERATOR"];
}

- (IBAction) shoPanicButtonScreen : (id)sender {
    [self.superViewController loadPanicButtonScreen];
}

@end
