//
//  RKCSVHelper.m
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKCSVHelper.h"
#import "CHCSVParser.h"
#import "Password.h"

@implementation RKCSVHelper

+ (BOOL)createCSVFileAtPath:(NSString *)path forPasswordList:(NSArray *)passwords
{
    if(path == nil || [passwords count] == 0)
        return FALSE;
    
    CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initForWritingToCSVFile:path];
    if(csvWriter == nil)
        return FALSE;
    
    for(Password *pwd in passwords)
    {
        [csvWriter writeField:pwd.channel];
        [csvWriter writeField:pwd.identifier];
        [csvWriter writeField:pwd.alias];
        [csvWriter writeField:pwd.stringPassword];
        [csvWriter finishLine];
    }
    return TRUE;
}

@end
