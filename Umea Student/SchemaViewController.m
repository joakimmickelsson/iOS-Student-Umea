/*
 File: SchemaViewController.m
 
 Abstract: Visar scheman som användaren kan välja mellan att spara.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "SchemaViewController.h"

@interface SchemaViewController ()

@end

@implementation SchemaViewController
@synthesize schemaHandler;

- (void)viewWillAppear:(BOOL)animated
{
    [self setupManagedObjectContext];
        
    schemaHandler = [[SchemaHandler alloc] init];
    [schemaHandler setUpManagedObjectContext];
    
    self.navigationItem.title = nil;
       
    NSSortDescriptor *sortDescriptor1 = 
    [[NSSortDescriptor alloc] initWithKey:@"stored" ascending:NO];
    
    NSSortDescriptor *sortDescriptor2 = 
    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];      
    
    
    [self searchDataBase: [FetchRequest setupFetchRequest:@"Schema" :nil :sortDescriptors :self.managedObjectContext] :@"stored" :nil];
    
    //[self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
    dispatch_queue_t downloadQueue = dispatch_queue_create("Updating Schemas", NULL);
    
    dispatch_async(downloadQueue, ^{
                
        [schemaHandler getSchemasFromWeb];
        
        self.managedObjectContext = schemaHandler.managedObjectContext;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispatch main");
  
                   NSSortDescriptor *sortDescriptor1 = 
                   [[NSSortDescriptor alloc] initWithKey:@"stored" ascending:NO];
                   
                   NSSortDescriptor *sortDescriptor2 = 
                   [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                   
                   NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];  
            
            NSLog(@"fetching if from main");

            [self searchDataBase: [FetchRequest setupFetchRequest:@"Schema" :nil :sortDescriptors : self.managedObjectContext] :@"stored" :nil];
            
            
            self.navigationItem.rightBarButtonItem = nil;
                       
                                           
        });
            

        
    });
    
    dispatch_release(downloadQueue);
   }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Schema *schema = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = schema.name;
    
    cell.detailTextLabel.text = schema.stored;
    
    if ([schema.stored isEqualToString:@"Mina Scheman"])
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        imageView.bounds = CGRectMake(0, 0, 27,27);
        
        
        cell.accessoryView = imageView;
    }  
    
    else if(cell.accessoryView)
    {
        cell.accessoryView = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Schema *schema = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
       
    if([schema.stored isEqualToString:@"Alla Scheman"]){
        
        schema.stored = @"Mina Scheman";

    }
    
    else
    {
        schema.stored = @"Alla Scheman"; 
    }
    
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Schema" inManagedObjectContext:[(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", schema.name];
    
    NSError *error = nil;
    
   Schema *storedSchema = [[[(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext] executeFetchRequest:request error:&error] lastObject];
    
    
    if (error) 
    {
        NSLog(@"Error Retrieving Schema");
        
    }
    
    else if(!storedSchema){
                
        storedSchema = [NSEntityDescription insertNewObjectForEntityForName:@"Schema" inManagedObjectContext:[(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext]];
        
        storedSchema.name = schema.name;
        storedSchema.uniqueId = schema.uniqueId;
        storedSchema.url = schema.url;
        storedSchema.stored = @"Mina Scheman";

        NSLog(@"storing schema%@",storedSchema.name);
  
    }
    
    else if(storedSchema){
        
        NSLog(@"deleting schema%@",schema.name);

            [[(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext] deleteObject:storedSchema];

    }
    
        [[(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext] save:&error];
    
    [self.tableView reloadData];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSSortDescriptor *sortDescriptor1 = 
    [[NSSortDescriptor alloc] initWithKey:@"stored" ascending:NO];
    
    NSSortDescriptor *sortDescriptor2 = 
    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];  
    
    NSPredicate *predicate = nil;
    
    
    if(![searchText isEqualToString:@""]){
        
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchText];
    }
    
    [self searchDataBase: [FetchRequest setupFetchRequest :@"Schema" 
                                                          :predicate
                                                          :sortDescriptors 
                                                          :self.managedObjectContext] 
                        :@"stored" :nil];
    
    
}

-(void)setupManagedObjectContext{
        if(self.managedObjectContext == nil){
            
            NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
            
            
            self.managedObjectContext = [[NSManagedObjectContext alloc] init];
            
            [self.managedObjectContext setPersistentStoreCoordinator:[moc persistentStoreCoordinator]];
            
            [self.managedObjectContext setUndoManager:nil];
            
        }
        
}
    

@end
