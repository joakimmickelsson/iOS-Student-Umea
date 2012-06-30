/*
 File: TableViewController.m
 
 Abstract: Denna klass är till för att kunna visa tableviews utan att behöva koda alla delegate- och datasourcefunktioner själv till varje tableview.
 Denna klass inheritar man ifrån så behöver man bara beskriva: CellForRowAtIndexPath själv för att få tableview att visas.
 
 Måste även köra SearchDatabasefunktionen för att ladda self.fetchresultscontrollern med core data object.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "TableViewController.h"

@implementation TableViewController

@synthesize tableView;
@synthesize searchBar;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

-(void)searchDataBase: (NSFetchRequest *)fetchRequest : (NSString *)sectionNameKeyPath: (NSString *)cacheName{
    
    if(self.managedObjectContext == nil){
        NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext]; 
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[moc persistentStoreCoordinator]];
        self.managedObjectContext = context;  
    }
    
    
    NSError *error = nil;
    
    self.fetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest 
                                        managedObjectContext: self.managedObjectContext 
                                          sectionNameKeyPath:sectionNameKeyPath 
                                                   cacheName:cacheName];
    
    
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Error while fetching data: Error:  %@, %@", error, [error userInfo]);
    }
    
    [self.tableView reloadData];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listheader.png"]];
    
    imageView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 25);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 10)] ;
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, self.tableView.bounds.size.width - 10, 15)] ;
    
    label.text = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:15]];
    [headerView addSubview:label];
    
    return headerView;
    
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{    
    
    for(UIView *subView in theSearchBar.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setReturnKeyType:UIReturnKeyDone];
            [(UITextField *)subView setEnablesReturnKeyAutomatically:NO];
        }
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar

{
    return YES;
}








@end
