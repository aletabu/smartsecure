//
//  SendIncidentMessageServerRequest.h
//  Smart Secure
//
//  Created by Constanza Areco on 01/12/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "SendMessageServerRequest.h"
#import "ModeratorMessagesViewController.h"

@interface SendIncidentMessageServerRequest : SendMessageServerRequest {
    int eventPosition;
}

@property (strong, nonatomic)  NSString *eventId;
@property (strong, nonatomic)  ModeratorMessagesViewController *moderatorController;

- (void) setEventPosition : (int) position;

@end
