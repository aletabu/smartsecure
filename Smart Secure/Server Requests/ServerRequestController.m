//
//  ServerRequestController.m
//  aurora-iphone
//
//  Created by Constanza Areco on 08/04/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "ServerRequestController.h"
#import "LoginServerRequest.h"
#import "UserInfoServerRequest.h"
#import "PanicServerRequest.h"
#import "GeoreferenciationServerRequest.h"
#import "SendMessageServerRequest.h"
#import "GetIncidentMessagesServerRequest.h"
#import "SendIncidentMessageServerRequest.h"
#import "SendPushNotificationTokenServerRequest.h"

@implementation ServerRequestController
@synthesize viewController;

- (void) login : (NSString *) user : (NSString *) password : (SmartSecureViewController *) smartSecureController{
    
    LoginServerRequest *loginRequest = [[LoginServerRequest alloc] init];
    [loginRequest setCredentials:user: password];
    [loginRequest setRequestController : self];
    loginRequest.viewController = self.viewController;
    loginRequest.smartSecureController = smartSecureController;
    [loginRequest communicate];
}

- (void) updateUserNetwork {
    UserInfoServerRequest *userInfoRequest = [[UserInfoServerRequest alloc] init];
    userInfoRequest.viewController = self.viewController;
    [userInfoRequest setRequestController : self];

    [userInfoRequest communicate];
}

- (void) sendPanic {
    PanicServerRequest *panicRequest = [[PanicServerRequest alloc] init];
    panicRequest.viewController = self.viewController;
    [panicRequest setRequestController : self];
    
    [panicRequest communicate];
}

- (void) sendCoordinates {
    GeoreferenciationServerRequest *gpsRequest = [[GeoreferenciationServerRequest alloc] init];
    gpsRequest.viewController = self.viewController;
    [gpsRequest setRequestController : self];
    
    [gpsRequest communicate];

}


- (void) sendMessage : (NSString *) message {
    SendMessageServerRequest *sendMessageRequest = [[SendMessageServerRequest alloc] init];
    sendMessageRequest.viewController = self.viewController;
    sendMessageRequest.message = message;
    [sendMessageRequest setRequestController : self];
    
    [sendMessageRequest communicate];
    
}

- (void) sendIncidentMessage : (NSString *) message : (NSString *) eventId : (int) eventPosition  : (ViewController *) messgesController {
    
    SendIncidentMessageServerRequest *sendMessageRequest = [[SendIncidentMessageServerRequest alloc] init];
    sendMessageRequest.viewController = messgesController;
    sendMessageRequest.message = message;
    sendMessageRequest.eventId = eventId;
    [sendMessageRequest setEventPosition:eventPosition];
    [sendMessageRequest setRequestController : self];
    
    [sendMessageRequest communicate];
}


- (void) getIncidentsInfoForNetwork : (NSString *) networkId : (ViewController *) superViewController {
    GetIncidentMessagesServerRequest *getIncidentsInfoRequest = [[GetIncidentMessagesServerRequest alloc] init];
    getIncidentsInfoRequest.viewController = superViewController;
    getIncidentsInfoRequest.networkId = networkId;
    
    [getIncidentsInfoRequest communicate];
    
}


- (void) sendPushNotificationsToken : (NSString *) pushToken {
    
    SendPushNotificationTokenServerRequest *sendPushTokenRequest = [[SendPushNotificationTokenServerRequest alloc] init];
    sendPushTokenRequest.viewController = self.viewController;
    sendPushTokenRequest.pushToken = pushToken;
    [sendPushTokenRequest setRequestController : self];
    
    [sendPushTokenRequest communicate];
}

@end
