//
//  RKTextField.m
//  Rook
//
//  Created by Stefan Lage on 29/10/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import "RKTextField.h"

@implementation RKTextField

// Add behavior to enable shortcut
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
    // Check if Command key is pressed with another one
    if (([theEvent type] == NSKeyDown) && ([theEvent modifierFlags] & NSCommandKeyMask))
    {
        NSResponder * responder = [[self window] firstResponder];
        if ((responder != nil) && [responder isKindOfClass:[NSTextView class]])
        {
            NSTextView * textView = (NSTextView *)responder;
            NSRange range = [textView selectedRange];
            bool bHasSelectedTexts = (range.length > 0);
            // Get keyCode of Key down
            unsigned short keyCode = [theEvent keyCode];
            bool bHandled = false;

            if (keyCode == KEY_A || keyCode == KEY_Q)
            {// Key code = CMD + A or KEY_Q if user has an AZERTY Keyboard
                // Select textfield content
                [textView selectAll:self];
                bHandled = true;
            }
            else if (keyCode == KEY_Z)
            {// Key code = CMD + Z
                if ([[textView undoManager] canUndo])
                {
                    [[textView undoManager] undo];
                    bHandled = true;
                }
            }
            else if (keyCode == KEY_X && bHasSelectedTexts)
            {// Key code = CMD + X & text is selected
                [textView cut:self];
                bHandled = true;
            }
            else if (keyCode== KEY_C && bHasSelectedTexts)
            {// Key code = CMD + C
                [textView copy:self];
                bHandled = true;
            }
            else if (keyCode == KEY_V)
            {// Key code = CMD + V
                [textView paste:self];
                bHandled = true;
            }
            if (bHandled)
                return YES;
        }
    }
    // Nothing to do
    return NO;
}

@end
