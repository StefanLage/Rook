//
//  RKDashboardWindowController.m
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKDashboardWindowController.h"
#import "Password.h"

@implementation RKDashboardWindowController

@synthesize addChannelBtn, removeChannelBtn, cancelChannelModalBtn, saveChannelModalBtn, pastePasswordBtn;
@synthesize channelField, aliasField, identifierField, passwordField;
@synthesize channelModal, deleteModal, titleBarView, tableView = _tableView;
@synthesize context, passwordArrayController;
@synthesize revisionLabel, commitLabel;

#pragma mark - NSWindow Initialization
- (id) initWithMOContext:(NSManagedObjectContext*)mocontext
{
    if ((self = [super init]))
        self.context = mocontext;
    isEditing = false;
    return self;
}

- (NSString *) windowNibName
{
	return @"RKDashboardWindowController";
}

- (void) windowDidLoad
{
    [super windowDidLoad];
}

- (void)awakeFromNib
{
    [[self tableView] setTarget:self];
    [[self tableView] setDoubleAction:@selector(openEditChannelModal)];
    
    // Custom title bar size & view
    INAppStoreWindow *aWindow = (INAppStoreWindow*)[self window];
    aWindow.titleBarHeight = 40.0;
    self.titleBarView.frame = aWindow.titleBarView.bounds;
    self.titleBarView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [aWindow.titleBarView addSubview:self.titleBarView];
    
    // Setting Revision Tag
    NSBundle *mainBundle = nil;
    mainBundle = [NSBundle mainBundle];
    [[self revisionLabel] setStringValue:[mainBundle objectForInfoDictionaryKey:@"Revision"]];
    [[self commitLabel] setStringValue:[mainBundle objectForInfoDictionaryKey:@"Commit"]];
}

#pragma mark - Helpers

-(void) openModalWithPanel:(NSPanel*)panel
{
    [NSApp beginSheet:panel
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}

-(void) closeModalForPanel:(NSPanel*)panel andSender:(id)sender
{
    [NSApp endSheet:panel];
    [panel orderOut:sender];
}

-(BOOL) copyStringToPasteboard:(NSString*)string
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    return [pasteboard writeObjects:[NSArray arrayWithObject:string]];
}

-(void) clearFields
{
    [[self channelField] setStringValue:@""];
    [[self aliasField] setStringValue:@""];
    [[self identifierField] setStringValue:@""];
    [[self passwordField] setStringValue:@""];
}

#pragma mark - XIB & Click Action Bindings
//
//  MODALS
//
// Open Channel Modal
-(IBAction) openChannelModal:(id)sender
{
    [[self channelField] becomeFirstResponder];
    [[self channelModal] setTitle:@"Add"];
    [self openModalWithPanel:self.channelModal];
}
// Close Channel Modal
-(IBAction) closeChannelModal:(id)sender
{
    [self closeModalForPanel:self.channelModal andSender:sender];
    isEditing = false;
    [self clearFields];
    [[self pastePasswordBtn] setHidden:true];
}
// Open Delete Modal
-(IBAction) openDeleteModal:(id)sender
{
    [self openModalWithPanel:self.deleteModal];
}
// Close Delete Modal
-(IBAction) closeDeleteModal:(id)sender
{
    [self closeModalForPanel:self.deleteModal andSender:sender];
}
// Open Edit Channel Modal
-(void) openEditChannelModal
{
    // Retrieving object at index
    NSInteger indexRowSelected = [[self tableView] selectedRow];
    if([[[self passwordArrayController] arrangedObjects] count] < indexRowSelected)
        return;
    Password *pwd = [[[self passwordArrayController] arrangedObjects] objectAtIndex:indexRowSelected];
    
    // Filling fields w/ object property
    [[self channelField] setStringValue:pwd.channel];
    [[self aliasField] setStringValue:pwd.alias];
    [[self identifierField] setStringValue:pwd.identifier];
    [[self passwordField] setStringValue:pwd.password];
    
    // Opening edit modal
    [[self pastePasswordBtn] setHidden:false];
    [[self channelField] becomeFirstResponder];
    [[self channelModal] setTitle:@"Edit"];
    [self openModalWithPanel:self.channelModal];
    isEditing = true;
}

//
//  ENTITIES
//
// Add Channel
-(IBAction) addChannel:(id)sender
{
    // Creating Password entity
    Password *pwd = nil;
    if(!isEditing)
        pwd = [NSEntityDescription insertNewObjectForEntityForName:@"Password"
                                            inManagedObjectContext:[self context]];
    else
    {
        NSInteger indexRowSelected = [[self tableView] selectedRow];
        pwd = [[[self passwordArrayController] arrangedObjects] objectAtIndex:indexRowSelected];
    }

    [pwd setChannel:[[self channelField] stringValue]];
    [pwd setAlias:[[self aliasField] stringValue]];
    [pwd setIdentifier:[[self identifierField] stringValue]];
    [pwd setPassword:[[self passwordField] stringValue]];
    
    // Saving Context
    [[self context] save:nil];
    
    // Closing Modal
    [self closeChannelModal:nil];
}
// Delete Channel
-(IBAction) confirmDelete:(id)sender
{
    // Removing object at row index
    NSInteger indexRowSelected = [[self tableView] selectedRow];
    [[self passwordArrayController] removeObjectAtArrangedObjectIndex:indexRowSelected];

    // Saving Context
    [[self context] save:nil];
    
    // Closing Modal
    [self closeDeleteModal:nil];
}

-(IBAction) copyPasswordToPasteboard:(id)sender
{
    [self copyStringToPasteboard:[[self passwordField] stringValue]];
}

@end
