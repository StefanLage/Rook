//
//  NSMutableData+AES.m
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "NSMutableData+AES.h"

@implementation NSMutableData (AES)

- (NSMutableData *)encryptAES:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF16StringEncoding];
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, NULL, [self mutableBytes], [self length], buffer, bufferSize, &numBytesEncrypted);
    
    if(result == kCCSuccess)
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];

    free(buffer);
    return nil;
}

- (NSMutableData *)decryptAES:(NSString *)key
{
    char  keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF16StringEncoding];
    
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer_decrypt = malloc(bufferSize);
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt , kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, NULL, [self mutableBytes], [self length], buffer_decrypt, bufferSize, &numBytesEncrypted);
    
    if(result == kCCSuccess)
        return [NSMutableData dataWithBytesNoCopy:buffer_decrypt length:numBytesEncrypted];
    
    free(buffer_decrypt);
    return nil;
}

@end
