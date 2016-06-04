//
//  LoginAgainServerRequest.m
//  aurora-iphone
//
//  Created by Constanza Areco on 08/04/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "LoginAgainServerRequest.h"
#import "KeyChainHelper.h"

@implementation LoginAgainServerRequest

- (void) setPendingRequest : (AbstractServerRequest *) request {
    pendingServerRequest = request;
}

- (void) requestSucceded {
    
    [pendingServerRequest communicate];
}

- (NSString *) getUser {
    return [Keychain getStringForKey:@"username"];
}

- (NSString *) getPassword {
    return [Keychain getStringForKey:@"password"];
}

- (BOOL) credentialsAreStored {
    
    BOOL haveCredentials = NO;
    
    if ([self getUser]
        && [self getPassword])
    {
        _username = [Keychain getStringForKey:@"username"];
        _password = [Keychain getStringForKey:@"password"];
        haveCredentials = YES;
    }
    
    return haveCredentials;
}

- (void) communicate {
    
    if ([self credentialsAreStored]) {
        [self sendRequest];
    } else {
        [self displayLogin];
        
    }
}
@end
