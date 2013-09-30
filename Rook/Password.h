//
//  Password.h
//  Rook
//
//  Created by Matthieu on 2013-09-29.
//  Copyright (c) 2013 Matthieu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Password : NSManagedObject

@property (nonatomic, retain) NSString * channel;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSString * password;

@end
