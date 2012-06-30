/*
 File: FetchRequest.h
 
 Abstract:  Skapar en FetchRequest från inparametrarna.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <CoreData/CoreData.h>

@interface FetchRequest : NSFetchRequest

+(NSFetchRequest *)setupFetchRequest:(NSString *)entity 
                                    :(NSPredicate *)predicate
                                    :(NSArray *)sortDescriptors
                                    :(NSManagedObjectContext *)context;


@end