//
//  RKDashboardWindowController.h
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RKDashboardWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

#pragma mark - XIB Bindings
@property (nonatomic, retain) IBOutlet NSButton *addChannelBtn;
@property (nonatomic, retain) IBOutlet NSButton *removeChannelBtn;
@property (nonatomic, retain) IBOutlet NSButton *cancelChannelModalBtn;
@property (nonatomic, retain) IBOutlet NSButton *saveChannelModalBtn;
@property (nonatomic, retain) IBOutlet NSPanel *channelModal;
@property (nonatomic, retain) IBOutlet NSTableView *tableView;

#pragma mark - Logic datas
@property (strong) NSMutableArray *passwords;

#pragma mark - XIB Action Bindings
-(IBAction) addChannel:(id)sender;
-(IBAction) removeChannel:(id)sender;
-(IBAction) openChannelModal:(id)sender;
-(IBAction) closeChannelModel:(id)sender;

#pragma mark - NSTableView Datasource / Delegate
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView;

@end
