//
//  NSMutableData+AES.h
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSMutableData (AES)

- (NSMutableData *)encryptAES:(NSString *)key;
- (NSMutableData *)decryptAES:(NSString *)key;

@end