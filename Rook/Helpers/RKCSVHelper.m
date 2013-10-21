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
#import "RKCoreDataManager.h"

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

+ (BOOL)importFromCSVFileAtPath:(NSString *)path
{
    NSArray *csvArrayParsed = [NSArray arrayWithContentsOfCSVFile:path];
    if (csvArrayParsed == nil)
        return FALSE;
    
    NSManagedObjectContext *moc = [RKCoreDataManager sharedInstance].managedObjectContext;
    if(!moc)
        return FALSE;
    
    Password *pwd = nil;
    for(NSArray *password in csvArrayParsed)
    {
        if([password count] < 4)
            continue;
        pwd = [Password insertNewObjectIntoContext:moc];
        [pwd setChannel:[password objectAtIndex:0]];
        [pwd setIdentifier:[password objectAtIndex:1]];
        [pwd setAlias:[password objectAtIndex:2]];
        [pwd setStringPassword:[password objectAtIndex:3]];
        pwd = nil;
    }
    NSError *error = nil;
    if(![moc save:&error])
    {
        [[NSApplication sharedApplication] presentError:error];
        return FALSE;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:rkReloadTableViewNotificationName object:nil];
    
    return TRUE;
}


@end
