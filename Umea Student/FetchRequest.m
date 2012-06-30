/*
 File: FetchRequest.m
 
 Abstract:  Skapar en FetchRequest från inparametrarna.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "FetchRequest.h"

@implementation FetchRequest

+(NSFetchRequest *)setupFetchRequest:(NSString *)entity 
                                    :(NSPredicate *)predicate
                                    :(NSArray *)sortDescriptors
                                    :(NSManagedObjectContext *)context
{                                   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:entity 
                                      inManagedObjectContext:context];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
}




@end
