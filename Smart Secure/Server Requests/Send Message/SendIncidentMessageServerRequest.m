//
//  SendIncidentMessageServerRequest.m
//  Smart Secure
//
//  Created by Constanza Areco on 01/12/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "SendIncidentMessageServerRequest.h"

@implementation SendIncidentMessageServerRequest
@synthesize eventId, moderatorController;

- (NSData *) getRequestBody {
    NSMutableString *parameters = [[NSMutableString alloc] initWithFormat:@"message=%@", self.message];
        
    
    NSData *requestBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    
    return requestBody;
}

- (void) setEventPosition : (int) position {
    eventPosition = position;
}

- (NSURL *) getRequestURL {
    NSURL * url = [[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@%@", kSendIncidentMessageURL1, eventId,kSendIncidentMessageURL2]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return url;
}

- (void) requestSucceded {
    [self.viewController loadModeratorMessagesScreen : eventPosition];
}

@end
