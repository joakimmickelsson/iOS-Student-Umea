/*
 File: PlacesHandler.h
 
 Abstract: Hanterar nedhämtning av platserna från hitta.db och sparar dom som core data object.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import "Place.h"
#import "AppDelegate.h"

@interface PlacesHandler : NSObject

-(void)savePlacesToDatabaseContext: (NSArray *)placesarray;
- (NSArray *)getPlacesFromWeb;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;



@end
