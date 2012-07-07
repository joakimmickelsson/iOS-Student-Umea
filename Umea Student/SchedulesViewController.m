//
//  SchedulesViewController.m
//  Umea Student
//
//  Created by Joakim Mickelsson on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SchedulesViewController.h"

@interface SchedulesViewController ()

@end

@implementation SchedulesViewController
@synthesize schemasFromWebArray;
@synthesize storedSchemas;
@synthesize kursIds;
@synthesize myStoredSchemasFromWebArray;
@synthesize myNotStoredSchemasFromWebArray;
@synthesize searchBar;
@synthesize storedSchemasArray;


-(IBAction)pushBack:(id)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

-(void)fetchStoredSchemasFromCoreData{
    
    
    NSSortDescriptor *sortDescriptor1 = 
    [[NSSortDescriptor alloc] initWithKey:@"kursnamn" ascending:NO];
    
    NSSortDescriptor *sortDescriptor2 = 
    [[NSSortDescriptor alloc] initWithKey:@"kursid" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];  
    
    
    NSManagedObjectContext *moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
    NSError *error = nil;
    
    
    storedSchemas = [moc executeFetchRequest:[FetchRequest setupFetchRequest:@"Schema"                                                                                                                                                             
                                                                            :nil 
                                                                            :sortDescriptors
                                                                            : [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext]]
                     
                                       error:&error ] ;
    
} 

-(void)deleteAllStoredSchemas{
    
    NSManagedObjectContext *moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
    NSError *error = nil;
    
    
    NSArray *schemasToDelete = [moc executeFetchRequest:[FetchRequest setupFetchRequest:@"Schema"                                                                                                                                                             
                                                                                       :nil 
                                                                                       :nil
                                                                                       : [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext]]
                                
                                                  error:&error ] ;
    
    for(Schema *schema in schemasToDelete){
        
        [moc deleteObject:schema];
        
    }
    
    NSError *error2 = nil;
    
    [moc save:&error2];
    
    
}

-(void)createstoredKursIdsArray{
    
    kursIds = [[NSMutableArray alloc] init];
    NSLog(@"kursid%@",storedSchemas);
    
    if(storedSchemas){
        for (JSONSchema *schema in storedSchemas) {
            NSLog(@"kursid%@",schema.kursid);
            if(schema){
                [kursIds addObject:schema.kursid];
            }
        }
        
        
    }
    
    
    NSLog(@"kursids%@",kursIds);
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
        
    [self fetchStoredSchemasFromCoreData];
    [self createstoredKursIdsArray];
    
    schemasFromWebArray = [[NSMutableArray alloc] init];
    storedSchemasArray  = [[NSMutableArray alloc] init];
    
    [self getSchemasFromWeb];
    [self restoreDataSourceArrays];

    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSManagedObjectContext *moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
    [self deleteAllStoredSchemas];
    
    for (JSONSchema *schemaData in schemasFromWebArray){
        
        if([schemaData.stored isEqualToString:@"YES"]){
            
            Schema *schema = [NSEntityDescription insertNewObjectForEntityForName:@"Schema" inManagedObjectContext:moc];
            schema.kursnamn = schemaData.kursnamn;
            schema.url = schemaData.url;
            schema.kursid = schemaData.kursid;
            schema.hp = schemaData.hp;
            schema.kurskod = schemaData.kurskod;
            schema.stored = @"Mina Scheman";
            
        }
    }
    
    for (JSONSchema *schemaData in storedSchemasArray){
        
        if([schemaData.stored isEqualToString:@"YES"]){
            
            Schema *schema = [NSEntityDescription insertNewObjectForEntityForName:@"Schema" inManagedObjectContext:moc];
            schema.kursnamn = schemaData.kursnamn;
            schema.url = schemaData.url;
            schema.kursid = schemaData.kursid;
            schema.hp = schemaData.hp;
            schema.kurskod = schemaData.kurskod;
            schema.stored = @"Mina Scheman";
            
            
        }
        
        
    }
    
    
    NSError *error = nil;
    [moc save:&error];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        
        return @"Mina Scheman";
    }
    
    else{
        
        return @"Alla Scheman";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [myStoredSchemasFromWebArray count];
        
    }
    else{
        
        return [myNotStoredSchemasFromWebArray count];
    }
    
    
    // Return the number of rows in the section.
    return [schemasFromWebArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if(indexPath.section == 0){
        JSONSchema *schema = [myStoredSchemasFromWebArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =  schema.kursnamn;
        cell.detailTextLabel.text = schema.kursid;
        
        if( [schema.stored isEqualToString:@"YES"]){
            
            cell.accessoryType =  UITableViewCellAccessoryCheckmark;                          
        }
        
        else{
            
            cell.accessoryType =  UITableViewCellAccessoryNone;   
        }
        
        
    }
    else{
        JSONSchema *schema = [myNotStoredSchemasFromWebArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =  schema.kursnamn;
        cell.detailTextLabel.text = schema.kursid;
        
        if( [schema.stored isEqualToString:@"YES"]){
            
            cell.accessoryType =  UITableViewCellAccessoryCheckmark;                          
        }
        
        else{
            
            cell.accessoryType =  UITableViewCellAccessoryNone;   
        }
        
    }
    
    
    
    
    
    
    
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        JSONSchema *schema  = [myStoredSchemasFromWebArray objectAtIndex:indexPath.row];
        
        for( JSONSchema *superschema in storedSchemasArray){
            
            if([schema.kursid isEqualToString:superschema.kursid]){
                
                
                if([schema.stored isEqualToString:@"NO"]){
                    
                    schema.stored = @"YES";
                }
                else{
                    
                    schema.stored = @"NO";
                }
                
            }
            
            
        }
        
    }
    
    else {
        JSONSchema *schema  = [myNotStoredSchemasFromWebArray objectAtIndex:indexPath.row];
        NSLog(@"rowschema%@",schema.kursnamn);

        for( JSONSchema *superschema in schemasFromWebArray){
            
            if([schema.kursid isEqualToString:superschema.kursid]){
                
                
                if([schema.stored isEqualToString:@"NO"]){
                    
                    schema.stored = @"YES";
                }
                else{
                    
                    schema.stored = @"NO";
                }
                
            }
            
            
        }
    }
    
    NSLog(@"schemasfromwebarray%@",schemasFromWebArray);
    NSLog(@"stored%@",storedSchemasArray);
    NSLog(@"mystored%@",myStoredSchemasFromWebArray);
    NSLog(@"myNOTS%@",myNotStoredSchemasFromWebArray);

    
    [self restoreDataSourceArrays];
    
    NSLog(@"schemasfromwebarray%@",schemasFromWebArray);
    NSLog(@"stored%@",storedSchemasArray);
    NSLog(@"mystored%@",myStoredSchemasFromWebArray);
    NSLog(@"myNOTS%@",myNotStoredSchemasFromWebArray);

    [self.tableView reloadData ];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];


}
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(searchText == nil){
     
          [self restoreDataSourceArrays];

    }
    
    else if([searchText isEqualToString:@""]){
        
          [self restoreDataSourceArrays];
  
    }
    
    else{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"SELF.kursnamn CONTAINS[cd] %@",searchText];
        
    
        
        myNotStoredSchemasFromWebArray = [NSMutableArray arrayWithArray:[self.schemasFromWebArray filteredArrayUsingPredicate:predicate]];
        myStoredSchemasFromWebArray = [NSMutableArray arrayWithArray:[self.storedSchemasArray filteredArrayUsingPredicate:predicate]];
    
}
    
    [self.tableView reloadData];
    
    
}


-(void)restoreDataSourceArrays{
    
    myNotStoredSchemasFromWebArray = schemasFromWebArray;
    myStoredSchemasFromWebArray = storedSchemasArray;
    
    
}

- (void)getSchemasFromWeb {
    
    if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte hämta scheman från internet"]){
        
        NSLog(@"Getting schema From Web");
        
        NSURL *nsUrl = [NSURL URLWithString:@"http://benjy.umdc.umu.se/api/schema.php"];
        
        NSData *schemaData = [NSData dataWithContentsOfURL:nsUrl];   
        
        if (schemaData){
            NSError *error = nil;
            NSDictionary *parsedSchemas = [NSJSONSerialization JSONObjectWithData:schemaData 
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&error]; 
            NSLog(@"Finished: Getting SCHEMA From Web");
            NSArray *schemaArray = [NSArray arrayWithArray:[parsedSchemas valueForKey:@"items"]]; 
            
            myStoredSchemasFromWebArray = [[NSMutableArray alloc] init];
            myNotStoredSchemasFromWebArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *schemadata in schemaArray){
                
                JSONSchema *schema = [[JSONSchema alloc] init];
                
                schema.kursnamn  = [schemadata objectForKey:@"kursnamn"];
                schema.url = [schemadata objectForKey:@"url"];
                schema.kursid = [schemadata objectForKey:@"kursid"];
                schema.hp = [schemadata objectForKey:@"hp"];
                schema.kurskod = [schemadata objectForKey:@"kurskod"];
                
                
                if( [kursIds containsObject:schema.kursid]){
                    schema.stored = @"YES";
                    
                    [storedSchemasArray addObject:schema];
                    
                    
                }
                
                else{
                    
                    schema.stored = @"NO";
                    [schemasFromWebArray addObject:schema];
                    
                }
                
                
                
                
                
            }
        }
        
        
        
    }
    
    
}


@end
