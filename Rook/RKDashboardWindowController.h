//
//  RKDashboardWindowController.h
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"
#import "RKTableView.h"

@interface RKDashboardWindowController : NSWindowController <RKTableViewDelegate>{
    bool isEditing;
}

#pragma mark - XIB Bindings
@property (strong, nonatomic) IBOutlet NSButton *addChannelBtn;
@property (strong, nonatomic) IBOutlet NSButton *removeChannelBtn;
@property (strong, nonatomic) IBOutlet NSButton *cancelChannelModalBtn;
@property (strong, nonatomic) IBOutlet NSButton *saveChannelModalBtn;
@property (strong, nonatomic) IBOutlet RKTableView *tableView;
@property (strong, nonatomic) IBOutlet NSTextField *channelField;
@property (strong, nonatomic) IBOutlet NSTextField *aliasField;
@property (strong, nonatomic) IBOutlet NSTextField *identifierField;
@property (strong, nonatomic) IBOutlet NSTextField *passwordField;
@property (strong, nonatomic) IBOutlet NSPanel *channelModal;
@property (strong, nonatomic) IBOutlet NSPanel *deleteModal;
@property (strong, nonatomic) IBOutlet NSButton *pastePasswordBtn;
@property (strong, nonatomic) IBOutlet NSTextField *revisionLabel;
@property (strong, nonatomic) IBOutlet NSTextField *commitLabel;
@property (strong, nonatomic) IBOutlet NSView *titleBarView;

#pragma mark - Logic datas
@property (strong, nonatomic) IBOutlet NSArrayController *passwordArrayController;
@property (weak, nonatomic) NSManagedObjectContext *context;

#pragma mark - XIB Action Bindings
- (IBAction)addChannel:(id)sender;
- (IBAction)openChannelModal:(id)sender;
- (IBAction)closeChannelModal:(id)sender;
- (IBAction)confirmDelete:(id)sender;
- (IBAction)openDeleteModal:(id)sender;
- (IBAction)closeDeleteModal:(id)sender;
- (IBAction)copyPasswordToPasteboard:(id)sender;
- (IBAction)exportToCSV:(id)sender;
- (IBAction)importFromCSV:(id)sender;

#pragma mark - Helper
+ (NSString *)windowNibName;

@end
