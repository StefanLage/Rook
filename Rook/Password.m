//
//  Password.m
//  Rook
//
//  Created by Matthieu on 2013-09-29.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "Password.h"
#import "NSString+AESMutableData.h"

@implementation Password

@dynamic channel;
@dynamic identifier;
@dynamic alias;
@dynamic password;

- (void)setStringPassword:(NSString *)password
{
    [self willChangeValueForKey:@"password"];
    [self setPrimitiveValue:[password encryptAES] forKey:@"password"];
    [self didChangeValueForKey:@"password"];
}

- (NSString *)stringPassword
{
    return [[NSString string] decryptAESWithData:[self primitiveValueForKey:@"password"]];
}

@end
