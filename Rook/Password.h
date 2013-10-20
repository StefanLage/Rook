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

@property (strong, nonatomic) NSString * channel;
@property (strong, nonatomic) NSString * identifier;
@property (strong, nonatomic) NSString * alias;
@property (strong, nonatomic) NSString * password;

@end
