/*
 File: PlacesTableView.m
 
 Abstract: Detta NSObject Hanterar Platslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Denna sidoscrollande tableview är inkapslad i en ram uppbyggd i MainViewController i storyboarden.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "PlacesTableView.h"

@implementation PlacesTableView

@synthesize fetchedResultsController;
@synthesize tableView;
@synthesize navigationController;
@synthesize offset;
@synthesize scrollDirection;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.fetchedResultsController sections] count];
}

- (IBAction)scrollScrollViewToEvents:(id)sender {
}

- (IBAction)scrollScrollViewToHome:(id)sender {
}

- (IBAction)scrollScrollViewToNews:(id)sender {
}

-(void)setUpPlacesTableView{
    
    
    self.tableView.transform = CGAffineTransformMakeRotation(M_PI_2);
      
    NSManagedObjectContext* moc = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = 
    [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
    
    
    NSPredicate *predicate = nil;
    
    [self searchDataBase: [FetchRequest setupFetchRequest:@"Place" :predicate :sortDescriptors :moc] :@"type" :nil];
    
    [self.tableView reloadData];
      
}

- (void)scrollViewDidScroll:(UITableView *)sender {
    
    
    if (offset > sender.contentOffset.y){
        scrollDirection = @"RIGHT";
        
        
    }
    else if (offset < sender.contentOffset.y) {
        scrollDirection = @"LEFT";
        
    }
    
    offset = sender.contentOffset.y;
    
}

-(void)searchDataBase: (NSFetchRequest *)fetchRequest : (NSString *)sectionNameKeyPath: (NSString *)cacheName{
    
    
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


- (HorizontalPlaceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categoryCell";
    HorizontalPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.typeLabel.text = [[[self.fetchedResultsController sections] objectAtIndex:[[self.fetchedResultsController sections] count] - indexPath.row -1] name ];
    
    
    [cell.typeLabel setTextAlignment:UITextAlignmentCenter];
    
    
    if([scrollDirection isEqualToString:@"LEFT"]){
        
        cell.transform = CGAffineTransformMakeRotation(-M_PI*0.75);
        
        
        
        [UIView animateWithDuration: 0.35
                         animations: ^{
                             
                             [UIView beginAnimations : @"Spin animation" context:nil];
                             [UIView setAnimationDuration:0.35];
                             [UIView setAnimationBeginsFromCurrentState:NO];
                             
                             cell.transform = CGAffineTransformMakeRotation(-M_PI_2);
                             
                             [UIView commitAnimations];
                         }completion: ^(BOOL finished){
                         }
         ];
        
    }
    
    else if([scrollDirection isEqualToString:@"RIGHT"]){
        
        cell.transform = CGAffineTransformMakeRotation(-M_PI_4);
        
        
        [UIView animateWithDuration: 0.35
                         animations: ^{
                             
                             [UIView beginAnimations : @"Spin animation" context:nil];
                             [UIView setAnimationDuration:0.35];
                             [UIView setAnimationBeginsFromCurrentState:NO];
                             
                             cell.transform = CGAffineTransformMakeRotation(-M_PI_2);
                             
                             [UIView commitAnimations];
                         }completion: ^(BOOL finished){
                         }
         ];
        
        
    }
    
    return cell;
}




@end
