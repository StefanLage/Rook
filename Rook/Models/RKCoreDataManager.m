//
//  RKCoreDataManager.m
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKCoreDataManager.h"

@implementation RKCoreDataManager

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;


#pragma mark - Lifecycle

+ (RKCoreDataManager *)sharedInstance
{
    static RKCoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [RKCoreDataManager new];
    });
    return sharedInstance;
}

#pragma mark - Core Data

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
        return _managedObjectModel;
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Rook" withExtension:@"momd"];
    if(!modelURL)
        modelURL = [[NSBundle mainBundle] URLForResource:@"Rook" withExtension:@"mom"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    // MOM
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom)
    {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;

    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:[self sourceStoreType]
                                                   configuration:nil
                                                             URL:[self sourceStoreURL]
                                                         options:nil
                                                           error:&error])
    {
        NSFileManager *fileManager = [NSFileManager new];
        [fileManager removeItemAtPath:[self sourceStoreURL].path error:nil];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }

    return _persistentStoreCoordinator;
}

#pragma mark -

- (NSURL *)sourceStoreURL
{
    return [[self applicationFilesDirectory] URLByAppendingPathComponent:rkCoreDataFile];
}

- (NSString *)sourceStoreType
{
    return NSSQLiteStoreType;
}

- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self sourceStoreType]
                                                                      URL:[self sourceStoreURL]
                                                                    error:error];
}

- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:rkAppSupportDir];
}

#pragma mark - Migration

- (BOOL)isMigrationNeeded
{
    NSError *error = nil;
    
    // Check if we need to migrate
    NSDictionary *sourceMetadata = [self sourceMetadata:&error];
    BOOL isMigrationNeeded = NO;
    
    if (sourceMetadata != nil)
    {
        NSManagedObjectModel *destinationModel = [self managedObjectModel];
        // Migration is needed if destinationModel is NOT compatible
        isMigrationNeeded = ![destinationModel isConfiguration:nil
                                   compatibleWithStoreMetadata:sourceMetadata];
    }
    else
    {
        if(error)
           [[NSApplication sharedApplication] presentError:error];
    }
    return isMigrationNeeded;
}

@end
