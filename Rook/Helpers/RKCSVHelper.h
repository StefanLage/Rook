//
//  RKCSVHelper.h
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKCSVHelper : NSObject

+ (BOOL)createCSVFileAtPath:(NSString *)path forPasswordList:(NSArray *)passwords;
+ (BOOL)importFromCSVFileAtPath:(NSString *)path;

@end
