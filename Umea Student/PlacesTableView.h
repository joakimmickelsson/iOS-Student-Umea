/*
 File: PlacesTableView.h
 
 Abstract: Detta NSObject Hanterar Platslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Denna sidoscrollande tableview är inkapslad i en ram uppbyggd i MainViewController i storyboarden.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Place.h"
#import "PlacesTableView.h"
#import "HorizontalPlaceCell.h"
#import "FetchRequest.h"


@interface PlacesTableView : NSObject  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UINavigationController *navigationController;


-(void)searchDataBase: (NSFetchRequest *)fetchRequest : (NSString *)sectionNameKeyPath: (NSString *)cacheName;

@property (nonatomic,strong) NSString *scrollDirection;
@property (nonatomic) CGFloat offset;


- (IBAction)scrollScrollViewToEvents:(id)sender;
- (IBAction)scrollScrollViewToHome:(id)sender;
- (IBAction)scrollScrollViewToNews:(id)sender;


-(void)setUpPlacesTableView;


@end
