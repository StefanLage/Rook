//
//  RKDashboardWindowController.m
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKDashboardWindowController.h"
#import "Password.h"
#import "RKCoreDataManager.h"
#import "RKCSVHelper.h"

@implementation RKDashboardWindowController

@synthesize addChannelBtn, removeChannelBtn, cancelChannelModalBtn, saveChannelModalBtn, pastePasswordBtn;
@synthesize channelField, aliasField, identifierField, passwordField;
@synthesize channelModal, deleteModal, titleBarView, tableView = _tableView;
@synthesize passwordArrayController, context = _context;
@synthesize revisionLabel, commitLabel;

#pragma mark - NSWindow Initialization

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    if ((self = [super initWithWindowNibName:windowNibName]))
    {
        isEditing = false;
        _context = [RKCoreDataManager sharedInstance].managedObjectContext;
    }
    return self;
}

- (void)windowDidLoad
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
    
    // Registering for update
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:rkReloadTableViewNotificationName object:nil];
}

#pragma mark - Helpers

+ (NSString *)windowNibName
{
	return @"RKDashboardWindowController";
}

- (void)openModalWithPanel:(NSPanel *)panel
{
    [NSApp beginSheet:panel
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}

- (void)closeModalForPanel:(NSPanel *)panel andSender:(id)sender
{
    [NSApp endSheet:panel];
    [panel orderOut:sender];
}

- (BOOL)copyStringToPasteboard:(NSString *)string
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    return [pasteboard writeObjects:[NSArray arrayWithObject:string]];
}

- (void)clearFields
{
    [[self channelField] setStringValue:@""];
    [[self aliasField] setStringValue:@""];
    [[self identifierField] setStringValue:@""];
    [[self passwordField] setStringValue:@""];
}

#pragma mark - XIB & Click Action Bindings

// Open Channel Modal
- (IBAction)openChannelModal:(id)sender
{
    [[self channelField] becomeFirstResponder];
    [[self channelModal] setTitle:@"Add"];
    [self openModalWithPanel:self.channelModal];
}

// Close Channel Modal
- (IBAction)closeChannelModal:(id)sender
{
    [self closeModalForPanel:self.channelModal andSender:sender];
    isEditing = false;
    [self clearFields];
    [[self pastePasswordBtn] setHidden:true];
}

// Open Delete Modal
- (IBAction)openDeleteModal:(id)sender
{
    [self openModalWithPanel:self.deleteModal];
}

// Close Delete Modal
- (IBAction)closeDeleteModal:(id)sender
{
    [self closeModalForPanel:self.deleteModal andSender:sender];
}

// Open Edit Channel Modal
- (void)openEditChannelModal
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
    [[self passwordField] setStringValue:pwd.stringPassword];
    
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
- (IBAction)addChannel:(id)sender
{
    // Creating Password entity
    Password *pwd = nil;
    if(!isEditing)
        pwd = [NSEntityDescription insertNewObjectForEntityForName:@"Password"
                                            inManagedObjectContext:[RKCoreDataManager sharedInstance].managedObjectContext];
    else
    {
        NSInteger indexRowSelected = [[self tableView] selectedRow];
        pwd = [[[self passwordArrayController] arrangedObjects] objectAtIndex:indexRowSelected];
    }

    [pwd setChannel:[[self channelField] stringValue]];
    [pwd setAlias:[[self aliasField] stringValue]];
    [pwd setIdentifier:[[self identifierField] stringValue]];
    [pwd setStringPassword:[[self passwordField] stringValue]];
    
    // Saving Context
    [[RKCoreDataManager sharedInstance].managedObjectContext save:nil];
    
    // Closing Modal
    [self closeChannelModal:nil];
}

// Delete Channel
- (IBAction)confirmDelete:(id)sender
{
    // Removing object at row index
    NSInteger indexRowSelected = [[self tableView] selectedRow];
    [[self passwordArrayController] removeObjectAtArrangedObjectIndex:indexRowSelected];

    // Saving Context
    [[RKCoreDataManager sharedInstance].managedObjectContext save:nil];
    
    // Closing Modal
    [self closeDeleteModal:nil];
}

// Copy to pasteboard
- (IBAction)copyPasswordToPasteboard:(id)sender
{
    [self copyStringToPasteboard:[[self passwordField] stringValue]];
}

// Export passwords to CSV
- (IBAction)exportToCSV:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setResolvesAliases:NO];
    [openDlg setPrompt:@"Choose"];
    
    if([openDlg runModal] == NSOKButton)
    {
        NSString *filePath = [[openDlg directoryURL] relativePath];
        NSString *fileName = rkCSVFileOutputFormat;
        fileName = [filePath stringByAppendingString:fileName];
        [RKCSVHelper createCSVFileAtPath:fileName forPasswordList:[self.passwordArrayController arrangedObjects]];
    }
}

// Import passwords from CSV
- (IBAction)importFromCSV:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowsOtherFileTypes:NO];
    [openDlg setAllowedFileTypes:@[@"csv"]];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setResolvesAliases:NO];
    
    if([openDlg runModal] == NSOKButton)
    {
        NSString *filePath = [[openDlg URL] relativePath];
        [RKCSVHelper importFromCSVFileAtPath:filePath];
    }
}

#pragma mark - Notifications

- (void)reloadTableView
{
    if(self.tableView)
        [self.tableView reloadData];
}

@end
