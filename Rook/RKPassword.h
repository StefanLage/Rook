//
//  RKPassword.h
//  Rook
//
//  Created by Matthieu on 2013-09-26.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKPassword : NSObject

@property (strong) NSString *channel;
@property (strong) NSString *identifier;
@property (strong) NSString *password;

- (id) initWithChannel:(NSString*)channel identifier:(NSString*)identifier password:(NSString*)password;

@end
