//
//  ServerRequestController.h
//  aurora-iphone
//
//  Created by Constanza Areco on 08/04/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewController;
@class AbstractServerRequest;
@class SmartSecureViewController;
@class ModeratorMessagesViewController;

@interface ServerRequestController : NSObject


@property (strong, nonatomic) ViewController * viewController;

- (void) login : (NSString *) user : (NSString *) password : (SmartSecureViewController *) smartSecureController;
- (void) updateUserNetwork;
- (void) sendPanic;
- (void) sendCoordinates;
- (void) sendMessage : (NSString *) message;

- (void) getIncidentsInfoForNetwork : (NSString *) networkId : (ViewController *) superViewController;
- (void) sendIncidentMessage : (NSString *) message : (NSString *) eventId : (int) eventPosition  : (ViewController *) messgesController;
- (void) sendPushNotificationsToken : (NSString *) pushToken;
@end
