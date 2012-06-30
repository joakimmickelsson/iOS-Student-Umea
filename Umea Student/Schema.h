/*
 File: Schema.h
 
 Abstract: Ett SchemaObject
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface Schema : NSManagedObject

@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * uniqueId;
@property (nonatomic, strong) NSString * stored;


@end
