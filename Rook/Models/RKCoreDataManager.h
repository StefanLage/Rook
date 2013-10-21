//
//  RKCoreDataManager.h
//  Rook
//
//  Created by Matthieu on 10/21/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (RKCoreDataManager *)sharedInstance;
- (BOOL)isMigrationNeeded;

@end
