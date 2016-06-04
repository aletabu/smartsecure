//
//  PanicServerRequest.m
//  Smart Secure
//
//  Created by Constanza Areco on 16/07/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "PanicServerRequest.h"
#import "ConfigurationData.h"
#import "KeyChainHelper.h"

@implementation PanicServerRequest
@synthesize location;

- (NSURL *) getRequestURL {
    NSURL * url = [[NSURL alloc] initWithString:[kSendPanicURL  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return url;
}

- (BOOL) successResult : (NSString *) result {
	BOOL success = NO;
    NSDictionary * model = [responseData JSONValue];
    
	if ([model objectForKey:@"panic_list"])
    {
        success = YES;
        
	}
	return success;
}

- (NSData *) getRequestBody {
    NSMutableString *parameters;
    
    KeyChainHelper * keyChain = [[KeyChainHelper alloc] init];
    NSString *networkId =[[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"id"];
    
    location = [self.viewController getLocation];
    if (location) {
        parameters = [[NSMutableString alloc] initWithFormat:@"identifier=%@&network_id=%@&lat=%f&lon=%f", [self.viewController generateUniqueIdentifier], networkId, location.coordinate.latitude, location.coordinate.longitude];
    } else {
        parameters = [[NSMutableString alloc] initWithFormat:@"identifier=%@&network_id=%@", [self.viewController generateUniqueIdentifier],
                      networkId];

    }
    
    NSData *requestBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    
    return requestBody;
}

- (void) requestSucceded {
    if (location) {
        [requestController sendCoordinates];
    }
}

@end
