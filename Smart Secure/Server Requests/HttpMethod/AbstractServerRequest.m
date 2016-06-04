//
//  AbstractServerRequest.m
//  aurora-iphone
//
//  Created by Constanza Areco on 08/04/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "AbstractServerRequest.h"
#import "ConfigurationData.h"

@implementation AbstractServerRequest
@synthesize viewController, smartSecureController, retryTimer;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSURL *) getRequestURL {
    // Override this method
    return nil;
}

- (void) requestSucceded {
    [self displayNextScreen];
}

- (void) requestFailed {
    // Override this method
}
- (void) displayNextScreen {
    // Override this method
}



- (void) sendRequest {
    // Override this method
}

- (BOOL) successResult : (NSString *) result {
    // Override this method
    return YES;
}

- (void) communicate {
    [self sendRequest];
}

- (void) setRequestController : (ServerRequestController *) controller {
    requestController = controller;
}

#pragma mark NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {


    [self stopRetryTimer];
    
    if (response.statusCode == 200
        || response.statusCode == 201)
    {
        responseData = [[NSMutableData alloc] init];
        requestOK = YES;
    } else if (response.statusCode == 503) {
        requestOK = NO;
        [self showErrorAlert :NSLocalizedString(@"ServiceUnavailableErrorText", @"")];
    } else {
        [self requestFailed];
        requestOK = NO;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (connection == _connection) {
        [_connection cancel];
        _connection = nil;
    }
    if (requestOK) {
        [self requestSucceded];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
//    NSMutableString *result=[[NSMutableString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    
    if (connection == _connection) {
        [_connection cancel];
        _connection = nil;
        [self createRetryTimer];
    }
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

- (void) showErrorAlert : (NSString *) msg {
    [self showAlert:NSLocalizedString(@"Error", @"") :msg];
}

- (void) stopRetryTimer {
    if (retryTimer != nil) {
		[retryTimer invalidate];
	}
}

- (void) createRetryTimer {
    [self stopRetryTimer];
    retryTimer = [NSTimer scheduledTimerWithTimeInterval:[ConfigurationData connectionRetry] target:self selector:@selector(reconnect) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:retryTimer forMode:NSDefaultRunLoopMode];
    
}

- (void) reconnect {
    [self communicate];
}

@end
