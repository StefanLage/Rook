//
//  RKAppDelegate.m
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKAppDelegate.h"
#import "RKCoreDataManager.h"

@implementation RKAppDelegate

@synthesize dashboardWindowController = _dashboardWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if([[RKCoreDataManager sharedInstance] isMigrationNeeded])
        return;
    
    _dashboardWindowController = [[RKDashboardWindowController alloc] initWithWindowNibName:[RKDashboardWindowController windowNibName]];
    [_dashboardWindowController showWindow:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    if (![RKCoreDataManager sharedInstance].managedObjectContext)
        return NSTerminateNow;
    
    if (![[RKCoreDataManager sharedInstance].managedObjectContext commitEditing])
    {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[RKCoreDataManager sharedInstance].managedObjectContext hasChanges])
        return NSTerminateNow;
    
    NSError *error = nil;
    if (![[RKCoreDataManager sharedInstance].managedObjectContext save:&error])
    {
        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result)
            return NSTerminateCancel;

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn)
            return NSTerminateCancel;
    }

    return NSTerminateNow;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[RKCoreDataManager sharedInstance].managedObjectContext undoManager];
}

@end
