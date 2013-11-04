//
//  RKTableView.h
//  Rook
//
//  Created by Stefan Lage on 04/11/13.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

@protocol RKTableViewDelegate;

@interface RKTableView : NSTableView
#define KEY_DELETE 51
@property (retain, nonatomic) id<RKTableViewDelegate> del_delegate;
@end

@protocol RKTableViewDelegate <NSObject>
- (void)delete_row:(BOOL)value;
@end
