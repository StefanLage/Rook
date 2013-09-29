//
//  RKDashboardWindowController.m
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKDashboardWindowController.h"
#import "RKPassword.h"

@implementation RKDashboardWindowController

@synthesize addChannelBtn, removeChannelBtn, cancelChannelModalBtn, saveChannelModalBtn;
@synthesize channelModal;
@synthesize passwords;
@synthesize tableView = _tableView;

#pragma mark - NSWindow Initialization
- (id) init
{
    if ((self = [super init])) {}
    return self;
}

- (NSString *) windowNibName {
	return @"RKDashboardWindowController";
}

- (void) windowDidLoad
{
    [super windowDidLoad];
}

#pragma mark - XIB Action Bindings
// Open Channel Modal
-(IBAction) openChannelModal:(id)sender
{
    [NSApp beginSheet:self.channelModal
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}
// Close Channel Modal
-(IBAction) closeChannelModel:(id)sender
{
    [NSApp endSheet:self.channelModal];
    [self.channelModal orderOut:sender];
}
// Add Channel
-(IBAction) addChannel:(id)sender
{
    NSLog(@"Add Channel");
}
// Remove Channel
-(IBAction) removeChannel:(id)sender
{
    NSLog(@"Remove Channel");
}


#pragma - Table View Datasource
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    RKPassword *password = [self.passwords objectAtIndex:row];
    if(password == nil)
        return @"undefined";
    if( [tableColumn.identifier isEqualToString:@"ChannelColumn"] )
        return [password channel];
    else if( [tableColumn.identifier isEqualToString:@"IdentifierColumn"] )
        return [password identifier];
    return @"undefined";
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"count");
    return [self.passwords count];
}

@end
