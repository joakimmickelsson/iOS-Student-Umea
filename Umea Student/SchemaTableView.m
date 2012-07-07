/*
 File: SchemaTableView.m
 
 Abstract: Detta NSObject Hanterar Schemalistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */
#import "SchemaTableView.h"


@implementation SchemaTableView

@synthesize fetchedResultsController;
@synthesize tableView;
@synthesize navigationController;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    if([[self.fetchedResultsController fetchedObjects] count]> 0 ){        
        
        return [[self.fetchedResultsController sections] count] ;
    }
    
    else
    {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([[self.fetchedResultsController fetchedObjects] count]> 0 )
    {
        
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
    
    else{
        
        return 1;
    }

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return 35;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    //Backgrund
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)] ;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listheader.png"]];
    
    imageView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 30);
    
    [headerView addSubview:imageView];
    
    //Texten
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, self.tableView.bounds.size.width - 10, 15)] ;
    
    if([[self.fetchedResultsController fetchedObjects] count] > 0 )
    {
        
         label.text = [[[self.fetchedResultsController sections] objectAtIndex:section] name];

    }
    
    else
    {
        
        label.text = @"Mina Scheman";
    }
    
       
    label.textColor         = [UIColor whiteColor];
    label.backgroundColor   = [UIColor clearColor];
    label.font              = [UIFont boldSystemFontOfSize:13];
    
    
    [headerView addSubview:label];
    
    
    //Inställningsknappen
    UIButton *addSchemaButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [addSchemaButton setFrame:CGRectMake(271, 0, 30, 30)];
    
    [addSchemaButton addTarget:self 
                        action:@selector(addSchemaButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:addSchemaButton];

    
    return headerView;
    
}

-(void)setupSchemaTableView
{
    
    NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = 
    [[NSSortDescriptor alloc] initWithKey:@"kursnamn" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
    
    [self searchDataBase: [FetchRequest setupFetchRequest:@"Schema" :nil :sortDescriptors :moc] :@"stored" :nil];
        
    if([[self.fetchedResultsController fetchedObjects] count] > 0 ){
                
        self.tableView.frame = CGRectMake(328,10,305, 35*[[self.fetchedResultsController fetchedObjects] count] + 30);
        
    }
      
    else 
    {
                
        self.tableView.frame = CGRectMake(
                                             328,         
                                             10, 
                                             305,
                                             65);
    
        
    }
    
      self.tableView.layer.cornerRadius = 10;
      self.tableView.layer.borderWidth = 0.1;
      self.tableView.layer.borderColor = [UIColor blackColor].CGColor;
    
        
}



-(void)addSchemaButtonPressed:(id)sender 
{
    
    
      SchedulesViewController *schedulesViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"schemastableviewcontroller"];
    
    [self.navigationController pushViewController:schedulesViewController animated:YES];
}

-(void)searchDataBase: (NSFetchRequest *)fetchRequest : (NSString *)sectionNameKeyPath: (NSString *)cacheName
{


    NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext]; 

    
    NSError *error = nil;
    
    self.fetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest 
                                        managedObjectContext: moc 
                                          sectionNameKeyPath:sectionNameKeyPath 
                                                   cacheName:cacheName];
    
    
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error while fetching data: Error:  %@, %@", error, [error userInfo]);
    }
    
    [self.tableView reloadData];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    if([[self.fetchedResultsController fetchedObjects] count] > 0 )
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        JSONSchema *schema = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = schema.kursnamn;
        cell.userInteractionEnabled = YES;
        return cell;

    }
    
    else
    {
        static NSString *CellIdentifier = @"noSchemaCell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        
        //   cell.textLabel.text = @"Du har inga Scheman Sparade";
        // cell.detailTextLabel.text = @"Klicka här för att lägga till";
        
        cell.userInteractionEnabled = NO;    return cell;

        
    }
    


}

@end