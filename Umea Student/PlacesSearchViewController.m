/*
 File: PlacesSearchViewController.m
 
 Abstract:  Applikationens Sökvy för platser. Från förstoringsglaset på Mapview.
 Sorterar platserna efter den kategori som klickades på i huvudfönstret.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "PlacesSearchViewController.h"

@interface PlacesSearchViewController ()

@end

@implementation PlacesSearchViewController

@synthesize initialCategorySortString;


-(IBAction)pushBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    
    
    self.navigationItem.title = nil;
    
    self.managedObjectContext = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];

    
    NSSortDescriptor *sortDescriptor1 = 
    [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    
    NSSortDescriptor *sortDescriptor2 = 
    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];      
    
    NSPredicate *predicate = nil;
    
    if(!(initialCategorySortString == nil)){
         predicate = [NSPredicate predicateWithFormat:@"type == %@",initialCategorySortString];

    }

    [self searchDataBase: [FetchRequest setupFetchRequest:@"Place" :predicate :sortDescriptors :self.managedObjectContext] :@"type" :nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = place.name;
    
    cell.detailTextLabel.text = place.type;
    
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSSortDescriptor *sortDescriptor1 = 
    [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    
    NSSortDescriptor *sortDescriptor2 = 
    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];  
    
    NSPredicate *predicate = nil;
    
    
    if(![searchText isEqualToString:@""]){
        
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchText];
    }
    
    else{
    
        predicate = [NSPredicate predicateWithFormat:@"type == %@", initialCategorySortString];
    }
    
    [self searchDataBase: [FetchRequest setupFetchRequest :@"Place" 
                                                          :predicate
                                                          :sortDescriptors 
                                                          :self.managedObjectContext] 
                        :@"type" :nil];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"FromPlacesToMapSegue"]) {
        
        MapViewController *mapViewController = (MapViewController *) segue.destinationViewController;
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        
        mapViewController.place = [self.fetchedResultsController objectAtIndexPath:selectedRowIndex];
        
    }
}

@end
