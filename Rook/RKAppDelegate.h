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
#import "RKCoreDataManager.h"

@interface RKAppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong, nonatomic) RKDashboardWindowController *dashboardWindowController;

@end
