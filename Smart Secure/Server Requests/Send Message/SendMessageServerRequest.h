//
//  SendMessageServerRequest.h
//  Smart Secure
//
//  Created by Constanza Areco on 16/07/13.
//  Copyright (c) 2013 SmartSecure. All rights reserved.
//

#import "AbstractPOSTServerRequest.h"

@interface SendMessageServerRequest : AbstractPOSTServerRequest
@property (strong, nonatomic)  CLLocation *location;
@property (strong, nonatomic)  NSString *message;
@property (strong, nonatomic)  NSString *networkId;

@end
