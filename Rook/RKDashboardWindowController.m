//
//  RKDashboardWindowController.m
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKDashboardWindowController.h"

@implementation RKDashboardWindowController

@synthesize addBtn, removeBtn, editWindow;

- (id) initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if(self){}
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}



-(IBAction) openModal:(id)sender
{
    [NSApp beginSheet:self.editWindow
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}

-(IBAction) closeModal:(id)sender
{
    [NSApp endSheet:editWindow];
    [editWindow orderOut:sender];
}


-(IBAction) addBtnAction:(id)sender
{
}

-(IBAction) removeBtnAction:(id)sender
{
}

@end
