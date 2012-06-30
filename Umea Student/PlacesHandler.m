/*
 File: PlacesHandler.m
 
 Abstract: Hanterar nedhämtning av platserna från hitta.db och sparar dom som core data object.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "PlacesHandler.h"
@implementation PlacesHandler
@synthesize managedObjectContext;

- (NSArray *)getPlacesFromWeb {
    
    NSLog(@"Getting Places From Web");
    
    NSURL *url = [NSURL URLWithString:@"http://hitta.db.umu.se/hitta/rest/search?q=&hl=sv"];
    
    NSData *placesData = [NSData dataWithContentsOfURL:url];   

    if (placesData){
        NSError *error = nil;
        NSDictionary *parsedPlaces = [NSJSONSerialization JSONObjectWithData:placesData 
                                                          options:NSJSONReadingMutableContainers
                                                            error:&error]; 
        NSLog(@"Finished: Getting Places From Web");
        return [NSArray arrayWithArray:[parsedPlaces valueForKey:@"items"]];  

    }
    
return nil;
}

-(void)saveDatabase{
        
    NSError *saveError = nil;
    
    [managedObjectContext save:&saveError];
    
    if (saveError != nil) {
        NSLog(@"[%@ saveContext] Error saving context: Error = %@, details = %@",[self class], saveError,saveError.userInfo);
    }        
    else {
        NSLog(@"Database Saved");
        
    }
}   
-(void)savePlacesToDatabaseContext: (NSArray *)placesarray {
  
    
    
    NSArray *placeTypes = [[NSArray alloc] initWithObjects:@"",@"Sal",@"Hus",@"",@"Mat och Fik",@"Affärer",@"Parkeringar",@"Busshållplatser",@"Campus",@"Datorsalar",@"Grupprum",@"Konferensrum",@"Annat",@"NUS",@"Adress",@"Mikrovågsugnar",@"Service",@"Mässa",@"Cykelpumpar",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil ];                      
    
    NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
    if(self.managedObjectContext == nil){
    
        
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        [self.managedObjectContext setPersistentStoreCoordinator:[moc persistentStoreCoordinator]];
        
        [self.managedObjectContext setUndoManager:nil];
        
        managedObjectContext.mergePolicy = [[NSMergePolicy alloc]
                                            initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
    
    }
  
    

    
    
        for (NSDictionary *placedata in placesarray){
            
            Place *place = nil;
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            
            request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:managedObjectContext];
            
            request.predicate = [NSPredicate predicateWithFormat:@"uniqueId == %@", [placedata objectForKey:@"id"]];
            
            NSError *error = nil;
            place = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
            
            if (!error && !place) 
            {
                place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:managedObjectContext];
            }
            
            place.name = [placedata objectForKey:@"name"];
            place.floor = [placedata objectForKey:@"floor"];
            place.uniqueId = [placedata objectForKey:@"id"];
            place.type = [placeTypes objectAtIndex:[[placedata objectForKey:@"objectType"] intValue]];
            
            //    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
            
            
            place.latitude =   [[NSNumber alloc] initWithFloat: [[[placedata objectForKey:@"location"] objectAtIndex:0] floatValue]];
            
            place.longitude =   [[NSNumber alloc] initWithFloat: [[[placedata objectForKey:@"location"] objectAtIndex:1] floatValue]];
            
            
            
        }
        
        [self saveDatabase];
    


    

}
    

 

    
   


@end
