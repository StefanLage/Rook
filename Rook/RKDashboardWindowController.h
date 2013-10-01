//
//  RKDashboardWindowController.h
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface RKDashboardWindowController : NSWindowController {
    bool isEditing;
}

#pragma mark - XIB Bindings
@property (nonatomic, retain) IBOutlet NSButton *addChannelBtn;
@property (nonatomic, retain) IBOutlet NSButton *removeChannelBtn;
@property (nonatomic, retain) IBOutlet NSButton *cancelChannelModalBtn;
@property (nonatomic, retain) IBOutlet NSButton *saveChannelModalBtn;
@property (nonatomic, retain) IBOutlet NSTableView *tableView;
@property (nonatomic, retain) IBOutlet NSTextField *channelField;
@property (nonatomic, retain) IBOutlet NSTextField *aliasField;
@property (nonatomic, retain) IBOutlet NSTextField *identifierField;
@property (nonatomic, retain) IBOutlet NSTextField *passwordField;
@property (nonatomic, retain) IBOutlet NSPanel *channelModal;
@property (nonatomic, retain) IBOutlet NSPanel *deleteModal;
@property (nonatomic, retain) IBOutlet NSButton *pastePasswordBtn;
@property (nonatomic, retain) IBOutlet NSTextField *revisionLabel;
@property (nonatomic, retain) IBOutlet NSTextField *commitLabel;
@property (nonatomic, retain) IBOutlet NSView *titleBarView;

#pragma mark - Logic datas
@property (nonatomic, retain) IBOutlet NSArrayController *passwordArrayController;
@property (retain) NSManagedObjectContext *context;

#pragma mark - Initialization
- (id) initWithMOContext:(NSManagedObjectContext*)mocontext;

#pragma mark - XIB Action Bindings
-(IBAction) addChannel:(id)sender;
-(IBAction) openChannelModal:(id)sender;
-(IBAction) closeChannelModal:(id)sender;
-(IBAction) confirmDelete:(id)sender;
-(IBAction) openDeleteModal:(id)sender;
-(IBAction) closeDeleteModal:(id)sender;
-(IBAction) copyPasswordToPasteboard:(id)sender;
@end
