//
//  LoginAgainServerRequest.h
//  cleo-iphone
//
//  Created by Constanza Areco on 08/04/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "AbstractServerRequest.h"
#import "LoginServerRequest.h"

@interface LoginAgainServerRequest : LoginServerRequest {
    AbstractServerRequest *pendingServerRequest;
}

- (void) setPendingRequest : (AbstractServerRequest *) request;
@end
