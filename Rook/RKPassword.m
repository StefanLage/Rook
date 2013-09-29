//
//  RKPassword.m
//  Rook
//
//  Created by Matthieu on 2013-09-26.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKPassword.h"

@implementation RKPassword

@synthesize channel = _channel, identifier = _identifier, password = _password;

- (id) initWithChannel:(NSString*)channel identifier:(NSString*)identifier password:(NSString*)password
{
    if((self = [super init]))
    {
        _channel = channel;
        _identifier = identifier;
        _password = password;
    }
    return self;
}

@end
