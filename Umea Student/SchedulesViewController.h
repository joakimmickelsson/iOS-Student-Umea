//
//  SchedulesViewController.h
//  Umea Student
//
//  Created by Joakim Mickelsson on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONSchema.h"
#import "CheckInternetConnection.h"
#import "AppDelegate.h"
#import "FetchRequest.h"
#import "Schema.h"
//#import "MainViewController.h"
#import "SchemaTableView.h"

@interface SchedulesViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *schemasFromWebArray;
@property (nonatomic,strong) NSMutableArray *storedSchemasArray;

@property (nonatomic,strong) NSArray *storedSchemas;
@property (nonatomic,strong) NSMutableArray *kursIds;
@property (nonatomic,strong) NSMutableArray *myStoredSchemasFromWebArray;
@property (nonatomic,strong) NSMutableArray *myNotStoredSchemasFromWebArray;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;


-(void)getSchemasFromWeb;
-(void)fetchStoredSchemasFromCoreData;
-(void)createstoredKursIdsArray;
@end
