/*
 File: TableViewController.h
 
 Abstract: Denna klass är till för att kunna visa tableviews utan att behöva koda alla delegate- och datasourcefunktioner själv till varje tableview.
 Denna klass inheritar man ifrån så behöver man bara beskriva: CellForRowAtIndexPath själv för att få tableview att visas.
    
 Måste även köra SearchDatabasefunktionen för att ladda self.fetchresultscontrollern med core data object.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "Place.h"
#import "FetchRequest.h"
#import "AppDelegate.h"

@interface TableViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

-(void)searchDataBase: (NSFetchRequest *)fetchRequest : (NSString *)sectionNameKeyPath: (NSString *)cacheName;


@end
