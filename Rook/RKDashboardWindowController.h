//
//  RKDashboardWindowController.h
//  Rook
//
//  Created by Matthieu on 2013-09-15.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RKDashboardWindowController : NSWindowController

@property (nonatomic, retain) IBOutlet NSButton *addBtn;
@property (nonatomic, retain) IBOutlet NSButton *removeBtn;
@property (nonatomic, retain) IBOutlet NSPanel *editWindow;

-(IBAction) openModal:(id)sender;
-(IBAction) closeModal:(id)sender;
-(IBAction) addBtnAction:(id)sender;
-(IBAction) removeBtnAction:(id)sender;

@end
