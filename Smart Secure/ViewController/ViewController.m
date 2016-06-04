//
//  ViewController.m
//  Smart Secure
//
//  Created by Constanza Areco on 07/07/13.
//  Copyright (c) 2013 Smart Secure. All rights reserved.
//

#import "ViewController.h"
#import "EnterCredentialsViewController.h"
#import "AppDelegate.h"
#import "ConfigurationData.h"
#import "XMLParser.h"
#import "ChooseNetScreenViewController.h"
#import "PanicButtonViewController.h"
#import "TermsAndConditionsViewController.h"
#import "MessagesScreenViewController.h"
#import "AutoSizeManager.h"
#import "KeyChainHelper.h"
#import "ModeratorMessagesViewController.h"

NSString * uniqueIdentifier;

@interface ViewController ()

@end

@implementation ViewController
@synthesize location, locationManager, serverRequestController, model;

- (BOOL) isUserRegistered {
// TODO
    
    return NO;
}

- (void) updateModel : (id) newModel {
    [self storeUserInfo : newModel];
}

- (void)updateLocation {
    [locationManager startUpdatingLocation];
}

- (void) initLocalizationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [self updateLocation];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

- (void) loadChooseNetScreen : (NSString *) prevScreen {
    ChooseNetScreenViewController *chooseNetController = [[ChooseNetScreenViewController alloc] initWithNibName:@"ChooseNetScreenViewController" bundle:nil];
    chooseNetController.superViewController = self;
    chooseNetController.serverRequestController = self.serverRequestController;
    chooseNetController.previousScreen = prevScreen;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = chooseNetController;


}


- (void) loadPanicButtonScreen {
    
    PanicButtonViewController *panicController = [[PanicButtonViewController alloc] initWithNibName:@"PanicButtonViewController" bundle:nil];
    panicController.superViewController = self;
    panicController.serverRequestController = self.serverRequestController;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = panicController;
}

- (void) loadTermsAndConditionsScreen {
    
    TermsAndConditionsViewController *termsController = [[TermsAndConditionsViewController alloc] initWithNibName:[AutoSizeManager getCorrectNibFileName:@"TermsAndConditionsViewController"] bundle:nil];
    termsController.superViewController = self;
    termsController.serverRequestController = self.serverRequestController;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = termsController;
}

- (void) loadMessagesScreen {
    MessagesScreenViewController *messagesController = [[MessagesScreenViewController alloc] initWithNibName:@"MessagesScreenViewController" bundle:nil];
    messagesController.superViewController = self;
    messagesController.serverRequestController = self.serverRequestController;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = messagesController;
}

- (void) loadModeratorMessagesScreen : (int) eventPosition {
    
    ModeratorMessagesViewController *messagesController = [[ModeratorMessagesViewController alloc] initWithNibName:@"ModeratorMessagesViewController" bundle:nil];
    messagesController.superViewController = self;
    messagesController.serverRequestController = self.serverRequestController;
    [messagesController setEventPosition : eventPosition];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = messagesController;
    
}

- (BOOL) hasManyNetworks {
    BOOL manyNetworks = NO;
    NSDictionary * networks;
    networks = [self getUserNetworks];
    if ([networks count] > 1) {
        manyNetworks = YES;
    }
    return manyNetworks;
}

- (void) getUserInfoFromServer {
    [self.serverRequestController updateUserNetwork];
}


- (void) startRegisteredApplication {
    [self getUserInfoFromServer];
    [self loadRegisteredAppScreen];
}


- (void) loadEnterCredentialsScreen {
    
    EnterCredentialsViewController *credentialsController = [[EnterCredentialsViewController alloc] initWithNibName:@"EnterCredentialsViewController" bundle:nil];
    credentialsController.superViewController = self;
    credentialsController.serverRequestController = self.serverRequestController;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = credentialsController;
}

- (void) startRegistrationProcess {
    [self loadEnterCredentialsScreen];
}


- (void) loadConfigurationData {
	if(![self parseXMLConfiguration])
	{
		[self showErrorAlert];
		[self performSelector:@selector(exit) withObject:nil afterDelay:1.5];
	}
}

- (BOOL)parseXMLConfiguration {
    
	NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *xmlFile = [paths
						 stringByAppendingPathComponent:@"configuration.xml"];
    NSURL *xmlURL = [NSURL fileURLWithPath:xmlFile isDirectory:NO];
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	XMLParser *parser = [[XMLParser alloc] initXMLParser];
	[xmlParser setDelegate:parser];
	
	BOOL success = [xmlParser parse];
	
	return success;
}

- (BOOL) isApplicationFirstRun {
    BOOL firstRun = NO;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
        firstRun = YES;
    }
    
    return firstRun;
}


- (NSString *) getUserToken {
    KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
    return [keyChainHelper loadStoredToken];
}

- (NSString *) getUserName {
    return [self.model objectForKey:@"first_name"];
}

- (NSString *) getUserLastName {
    return [self.model objectForKey:@"last_name"];
}

- (NSDictionary *) getUserNetworks {
    KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
    return [[keyChainHelper loadNetworks] propertyList];
}

- (CLLocation *) getLocation {
    return location;
}

- (NSString *) generateUniqueIdentifier {
    int identifier = arc4random_uniform(29);
    
    NSDate *date = [NSDate date];
    ;
    uniqueIdentifier = [NSString stringWithFormat: @"%d-%f", identifier, ([date timeIntervalSince1970] * 1000)];
    return uniqueIdentifier;
    
}

- (NSString *) getUniqueIdentifier {
    if (uniqueIdentifier) {
        return uniqueIdentifier;
    } else {
        return [self generateUniqueIdentifier];
    }
}

- (void) saveInfoInKeyChain {
    KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
    [keyChainHelper saveToken:[self.model objectForKey:@"token"]];
    [self saveNetworkInfoInKeyChain: [self.model objectForKey:@"networks"]];
}

- (void) saveNetworkInfoInKeyChain : (NSDictionary *) networks {
    KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
    [keyChainHelper saveNetworks:[networks description]];
}

- (BOOL) moderatorMessagesScreenIsVisible : (UIViewController *) controller{
    BOOL isVisible = NO;
    
    if([controller isKindOfClass:[ModeratorMessagesViewController class]])
    {
        isVisible = YES;
    }
    
    return isVisible;
}

- (void) saveIncidentInfoInKeyChain : (NSDictionary *) eventsInfo : (NSString *) networkId  {
    
    KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
    [keyChainHelper saveEventsInfoForNetwork :networkId :[eventsInfo description]];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *controller = appDelegate.window.rootViewController;
    
    if ([self moderatorMessagesScreenIsVisible : controller]) {
        [((ModeratorMessagesViewController *) controller) updateInfo:eventsInfo];
    }
}

- (void) updateEventMessages {
    KeyChainHelper * keyChain = [[KeyChainHelper alloc] init];
    NSString *networkId =[[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"id"];
    if (networkId) {
        [self.serverRequestController getIncidentsInfoForNetwork: networkId :self];
    }
}

- (void) loadRegisteredAppScreen {
    [self loadPanicButtonScreen];
}

- (void) updateUserInfoAndLoadApplication {
    [self saveInfoInKeyChain];
    [self updatePushNotificationsId];
    [self loadChooseNetScreen : @"PANIC"];
}

- (void) storeUserInfo : (id)  newModel {
    self.model = newModel;
    if ([self userIsRegistered]) {
        [self updateUserInfoAndLoadApplication];
    } else {
        [self loadTermsAndConditionsScreen];
    }
}

- (void) cleanKeyChain {
    
    if ([self getUserToken]) {
        KeyChainHelper * keyChainHelper = [[KeyChainHelper alloc] init];
        [keyChainHelper removeAllKeyChain];
    }
}


- (BOOL) userIsRegistered {
    
    BOOL haveCredentials = NO;
    
    if ([self getUserToken])
    {
        haveCredentials = YES;
    }
    
    return haveCredentials;
}

- (void) updatePushNotificationsId {
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.pushToken
            && [self userIsRegistered]) {
        
        [self.serverRequestController sendPushNotificationsToken: appDelegate.pushToken];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    uniqueIdentifier = nil;
    self.serverRequestController = [[ServerRequestController alloc] init];
    self.serverRequestController.viewController = self;

    [self loadConfigurationData];
    
    [self initLocalizationManager];
    
    if ([self isApplicationFirstRun]) {
        [self cleanKeyChain];
    }
    
    if ([self userIsRegistered]) {
        [self startRegisteredApplication];
    } else {
        [self startRegistrationProcess];
    }
}

- (void) showErrorAlert {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"Error", @"")
						  message:NSLocalizedString(@"XMLConfigurationFileError", @"")
						  delegate:self
						  cancelButtonTitle:nil
						  otherButtonTitles:nil];
	[alert show];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [locationManager stopUpdatingLocation];
}
@end
