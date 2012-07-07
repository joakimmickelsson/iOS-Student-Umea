/*
 File: SchemaTableView.h
 
 Abstract: Detta NSObject Hanterar Schemalistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Schema.h"
#import "FetchRequest.h"
#import "SchedulesViewController.h"

@interface SchemaTableView : NSObject  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UINavigationController *navigationController;


-(void)searchDataBase: (NSFetchRequest *)fetchRequest : (NSString *)sectionNameKeyPath: (NSString *)cacheName;

-(void)setupSchemaTableView;


@end
