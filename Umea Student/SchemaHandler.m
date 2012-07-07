/*
 File: SchemaHandler.m
 
 Abstract: Hanterar nedhämtning av schemalänkar från applikationens server och lägger in dom i ett separat NSManagedObjectContext.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */


#import "SchemaHandler.h"

@implementation SchemaHandler

@synthesize managedObjectContext;

- (void)getSchemasFromWeb {
    
    if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte hämta scheman från internet"]){
        
        NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
        
        
        NSLog(@"Getting schema From Web");
        
        NSURL *nsUrl = [NSURL URLWithString:@"http://lidger.se/smart/googleschema.php"];
        
        NSData *schemaData = [NSData dataWithContentsOfURL:nsUrl];   
        
        if (schemaData){
            NSError *error = nil;
            NSDictionary *parsedSchemas = [NSJSONSerialization JSONObjectWithData:schemaData 
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error]; 
            NSLog(@"Finished: Getting SCHEMA From Web");
            NSArray *schemaArray = [NSArray arrayWithArray:[parsedSchemas valueForKey:@"items"]]; 
            
            for (NSDictionary *schemadata in schemaArray){
                
                
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                
                request.entity = [NSEntityDescription entityForName:@"Schema" inManagedObjectContext:moc];
                
                request.predicate = [NSPredicate predicateWithFormat:@"uniqueId == %@", [schemadata objectForKey:@"id"]];
                
                NSError *error = nil;
                
                Schema *storedSchema = nil;
                
                storedSchema = [[moc executeFetchRequest:request error:&error] lastObject];
                
                
                if (error) 
                {
                    NSLog(@"Error Retrieving Schema");
                }
                
                else{
                    
                    if(!storedSchema){
                        Schema *schema = [NSEntityDescription insertNewObjectForEntityForName:@"Schema" inManagedObjectContext:self.managedObjectContext];
                        schema.kursnamn = [schemadata objectForKey:@"name"];
                        schema.url = [schemadata objectForKey:@"url"];
                        schema.kursid = [schemadata objectForKey:@"id"];
                        schema.stored = @"Alla Scheman";
                        
                    }
                    
                }
                
                
            }
            
        }
    }
    
    else{
        
        //   [self getSchemasFromDataBase];
        
    }
}   


- (void)getSchemasFromWeb2 {
    
    if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte hämta scheman från internet"]){
        
        NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];

        
        NSLog(@"Getting schema From Web");
        
        NSURL *nsUrl = [NSURL URLWithString:@"http://lidger.se/smart/googleschema.php"];
        
        NSData *schemaData = [NSData dataWithContentsOfURL:nsUrl];   
        
        if (schemaData){
            NSError *error = nil;
            NSDictionary *parsedSchemas = [NSJSONSerialization JSONObjectWithData:schemaData 
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error]; 
            NSLog(@"Finished: Getting SCHEMA From Web");
            NSArray *schemaArray = [NSArray arrayWithArray:[parsedSchemas valueForKey:@"items"]]; 
    
            for (NSDictionary *schemadata in schemaArray){
                
                
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                
                request.entity = [NSEntityDescription entityForName:@"Schema" inManagedObjectContext:moc];
                
                request.predicate = [NSPredicate predicateWithFormat:@"uniqueId == %@", [schemadata objectForKey:@"id"]];
                
                NSError *error = nil;
                
                Schema *storedSchema = nil;
                
                storedSchema = [[moc executeFetchRequest:request error:&error] lastObject];
               
                Schema *schema = [NSEntityDescription insertNewObjectForEntityForName:@"Schema" inManagedObjectContext:self.managedObjectContext];
                
                schema.kursnamn = [schemadata objectForKey:@"name"];
                schema.url = [schemadata objectForKey:@"url"];
                schema.kursid = [schemadata objectForKey:@"id"];
                
                    
                if (error) 
                {
                    NSLog(@"Error Retrieving Schema");
                }
                
                
                   else if(storedSchema){
                        schema.stored = @"Mina Scheman";
                        
                    }
                    
                   else if(!storedSchema){
                            schema.stored = @"Alla Scheman";
                        
                    }
                    
                [moc deleteObject:schema];

                
                
                
            }
            
        }
    }
    
}

-(void)setUpManagedObjectContext{
    if(self.managedObjectContext == nil){
        
        NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
        
        
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        [self.managedObjectContext setPersistentStoreCoordinator:[moc persistentStoreCoordinator]];
        
        [self.managedObjectContext setUndoManager:nil];
        
    }

}


@end
