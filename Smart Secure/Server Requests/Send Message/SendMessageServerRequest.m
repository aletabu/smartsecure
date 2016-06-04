//
//  SendMessageServerRequest.m
//  Smart Secure
//
//  Created by Constanza Areco on 16/07/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "SendMessageServerRequest.h"
#import "ConfigurationData.h"
#import "KeyChainHelper.h"

@implementation SendMessageServerRequest
@synthesize location, message, networkId;


- (NSURL *) getRequestURL {
    NSURL * url = [[NSURL alloc] initWithString:[kSendMessageURL  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return url;
}

- (BOOL) successResult : (NSString *) result {
	BOOL success = NO;
    NSDictionary * model = [responseData JSONValue];
    
	if ([model objectForKey:@"status"]
        && ([[model objectForKey:@"status"] intValue] == 200))
    {
        success = YES;
        
	}
	return success;
}

- (NSData *) getRequestBody {
    NSMutableString *parameters;
    
    KeyChainHelper * keyChain = [[KeyChainHelper alloc] init];
    self.networkId =[[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"id"];
    
    
    location = [self.viewController getLocation];
    if (location) {
        parameters = [[NSMutableString alloc] initWithFormat:@"identifier=%@&text=%@&network_id=%@&lat=%f&lon=%f", [self.viewController getUniqueIdentifier], message, self.networkId,location.coordinate.latitude, location.coordinate.longitude];
    } else {
        parameters = [[NSMutableString alloc] initWithFormat:@"identifier=%@&text=%@", [self.viewController getUniqueIdentifier], message];
        
    }
    
    NSData *requestBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    
    return requestBody;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    if (connection == _connection) {
        [_connection cancel];
        _connection = nil;
    }
    if (requestOK) {
        [self requestSucceded];
    } else {
        [self requestFailed];
    }
    
}

- (void) requestFailed {
    [self showErrorAlert: NSLocalizedString(@"MessageSendError", @"")];
}

- (void) requestSucceded {
    [self.viewController loadPanicButtonScreen];
}

@end
