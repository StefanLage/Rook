//
//  NSString+AESMutableData.h
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AESMutableData)

- (NSMutableData *)encryptAES;
- (NSString *)decryptAESWithData:(NSData *)data;

@end