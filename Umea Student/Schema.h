/*
 File: Schema.h
 
 Abstract: Ett SchemaObject
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface Schema : NSManagedObject

@property (nonatomic, strong) NSString * hp;
@property (nonatomic, strong) NSString * kursid;
@property (nonatomic, strong) NSString * kurskod;
@property (nonatomic, strong) NSString * kursnamn;
@property (nonatomic, strong) NSString * startvecka;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * stored;


@end
