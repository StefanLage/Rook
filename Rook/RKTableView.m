//
//  RKTableView.m
//  Rook
//
//  Created by Stefan Lage on 04/11/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKTableView.h"

@implementation RKTableView

- (void)keyDown:(NSEvent *)event
{
    // Get keyCode of Key down
    unsigned short keyCode = [event keyCode];
    // Key is Del key
    if(keyCode == KEY_DELETE)
    {
        // No selected -> BEEEEEEP
        if([self selectedRow] == -1){
            NSBeep();
            return;
        }
        // Inform delegate that user press Del key
        if ([self.del_delegate respondsToSelector:@selector(delete_row:)])
            [self.del_delegate delete_row:YES];
    }
    [super keyDown:event];
}


@end
