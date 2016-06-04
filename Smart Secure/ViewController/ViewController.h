//
//  ViewController.h
//  Smart Secure
//
//  Created by Constanza Areco on 07/07/13.
//  Copyright (c) 2013 Smart Secure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerRequestController.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic)  CLLocationManager *locationManager;
@property (strong, nonatomic)  CLLocation *location;
@property (strong, nonatomic)  id model;
@property (strong, nonatomic)  ServerRequestController *serverRequestController;

- (void) loadEnterCredentialsScreen;
- (void) loadTermsAndConditionsScreen;
- (void) loadPanicButtonScreen;
- (void) loadChooseNetScreen : (NSString *) prevScreen;
- (void) loadMessagesScreen;
- (void) loadModeratorMessagesScreen : (int) eventPosition;

- (NSString *) getUniqueIdentifier;
- (NSString *) generateUniqueIdentifier;

- (NSString *) getUserToken;
- (NSString *) getUserName;
- (NSString *) getUserLastName;
- (NSDictionary *) getUserNetworks;
- (CLLocation *) getLocation;

- (void) saveInfoInKeyChain;
- (void) storeUserInfo : (id) model;
- (void) updateUserInfoAndLoadApplication;
- (void) updatePushNotificationsId;

- (void) saveNetworkInfoInKeyChain : (id) networks;
- (void) saveIncidentInfoInKeyChain : (NSDictionary *) eventsInfo : (NSString *) networkId;
- (void) updateEventMessages;
@end
