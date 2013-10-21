//
//  NSString+AESMutableData.m
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "NSString+AESMutableData.h"
#import "NSMutableData+AES.h"

@implementation NSString (AESMutableData)

- (NSMutableData *)encryptAES
{
    return [(NSMutableData *)[self dataUsingEncoding:NSUTF8StringEncoding] encryptAES:rkAESEncryptionKey];
}

- (NSString *)decryptAESWithData:(NSData *)data
{
    return [[NSString alloc] initWithData:[data.mutableCopy decryptAES:rkAESEncryptionKey] encoding:NSUTF8StringEncoding];
}

@end
