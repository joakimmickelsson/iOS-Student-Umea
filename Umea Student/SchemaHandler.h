/*
 File: SchemaHandler.h
 
 Abstract: Hanterar nedhämtning av schemalänkar från applikationens server och lägger in dom i ett separat NSManagedObjectContext.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import "Schema.h"
#import "CheckInternetConnection.h"

@interface SchemaHandler : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)getSchemasFromWeb;

-(void)setUpManagedObjectContext;


@end
