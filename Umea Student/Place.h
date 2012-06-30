/*
 File: Place.h
 
 Abstract: Ett platsobjekt som lagras i core data och representerar en plats från hitta.db.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber * floor;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * uniqueId;

@end
