//
//  RKAppDelegate.h
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RKDashboardWindowController.h"
#import "INAppStoreWindow.h"

@interface RKAppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong, nonatomic) RKDashboardWindowController *dashboardWindowController;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
