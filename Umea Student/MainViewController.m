/*
 File: MainViewController.m
 
 Abstract: Huvudfönstret i appen. Denna ställer in alla olika views som visas i huvudfönstret samt uppdaterar alla platser från hitta.db. 
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController;

@synthesize scrollView;
@synthesize schemaTableView;
@synthesize schemaShadowView;
@synthesize placesContainerView;
@synthesize placesTableView;
@synthesize placesShadowView;
@synthesize eventsTableView;
@synthesize sectionView;
@synthesize homeSection;
@synthesize eventsSection;
@synthesize infoSection;
@synthesize newsTableView;
@synthesize newsSection;
@synthesize studentInfoWebView;
@synthesize eventsContainerView;
@synthesize newsContainerView;


- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applikationIsBackToForeGround:) 
                                                 name:@"AppEnteredForeground" 
                                               object:nil];
    
    //Ställer in appens huvudfönster
    [scrollView setContentSize:CGSizeMake(1280,scrollView.frame.size.height)];
    
    //Scrolla scrollviewen till hemskärmen.
    
    self.scrollView.pagingEnabled = YES;
    
    [self scrollScrollViewToHome:nil];
    
    //[self.scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 480) animated:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"VIEW DID APPEAR");
    
    

    if([LastUpdate isTheAppRunningForTheFirstTime]){
        NSLog(@"First Time Running");

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setBool:NO forKey:@"studentAppFirstTimeUse"];
        
        [defaults synchronize];
        
    }
    
   else if([LastUpdate isTheAppRunningNewVersion] ){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [LastUpdate upgradeVersion];
        
        [defaults synchronize];
                NSLog(@"New Version");

        
       

    }
    
    
    NSLog(@"Loading Student Info");

    [self.studentInfoWebView load:@"http://google.se"];

    
    NSLog(@"VIEW DID APPEAR --------> DONE");

}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"VIEW WILL APPEAR");

    [self setupSchemaTableView];
    
    [self setupPlacesTableView];
    
    [self setUpShadows];
    
    self.eventsTableView.headerTitle = @"Evenemang";
    self.newsTableView.headerTitle = @"Nyheter";
    
    [self.newsTableView roundOfCorners];
    [self.eventsTableView roundOfCorners];
    [self.studentInfoWebView roundOfCorners];

    self.eventsContainerView.layer.cornerRadius = 10;
    self.eventsContainerView.layer.borderWidth = 0.1;
    self.eventsContainerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.newsContainerView.layer.cornerRadius = 10;
    self.newsContainerView.layer.borderWidth = 0.1;
    self.newsContainerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    self.studentInfoWebView.webView.frame = CGRectMake(8, 10, 305, 375);
    

    NSLog(@"VIEW WILL APPEAR ------> DONE");

}


//Laddar platslistan med platserna om det finns platser i databasen.
//Scrollar listan till början (egentligen slutet på listan, men listan är snedvriden så första elementet blir egentligen det sista.

-(void)setupPlacesTableView{
    NSLog(@"Setting up places Table View");
    
    [self.placesTableView setUpPlacesTableView];
    [self setUpPlacesContainer];
    
    if([[self.placesTableView.fetchedResultsController sections] count] > 0) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[[self.placesTableView.fetchedResultsController sections] count] -1 inSection:0];
        
        [self.placesTableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        NSLog(@"Det Finns Sparade Platser i Databasen");
    }    
    else { 
        NSLog(@"Det Finns INGA Sparade Platser i Databasen");

    }
    
    self.placesTableView.navigationController = self.navigationController;
    
    [self.placesTableView.tableView reloadData];
}



-(void)setupSchemaTableView{
    
    //Ställer in schema och platslistorna
    [self.schemaTableView setupSchemaTableView];
    [self.schemaTableView.tableView reloadData];
    
    
    
    
    //För att kunna segue från dessa tableviews
    self.schemaTableView.navigationController = self.navigationController;
    
    
    
    
    
}


-(void)setupEventsAndNewsTableViews{
    
    
    

    dispatch_queue_t eventsAndNewsQueue = dispatch_queue_create("Downloading Events and News", NULL);
    
    dispatch_async(eventsAndNewsQueue, ^{
        
        //Ställer in evenemang och nyhetstableviewna om internet finns flr att hämta rss data.
 NSLog(@"Checking internet for events and news");
        if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte hämta evenemang och nyheter"])
        {
                        
            if(![self.eventsTableView.tableViewIsLoaded isEqualToString:@"YES"]){
                
                NSLog(@"Downloading Events");
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.eventsTableView.spinner startAnimating];
                    
                });

                [self.eventsTableView setupEventsTableView]; 
                
                //  self.eventsTableView.tableViewIsLoaded = @"YES";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.eventsTableView stopSpinner];
                    [self.eventsTableView.tableView reloadData];
                    
                });
            }
            
            if(![self.newsTableView.tableViewIsLoaded isEqualToString:@"YES"]){
                
                NSLog(@"Downloading News");

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.eventsTableView.spinner startAnimating];
                    
                });
                
                [self.newsTableView setupNewsTableView];
                
                //   self.newsTableView.tableViewIsLoaded = @"YES";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [self.newsTableView stopSpinner];
                    
                    [self.newsTableView.tableView reloadData];
                    
                    
                });
                
                        
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.navigationItem.rightBarButtonItem = nil;
                
            });
            
            
        }
        
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.navigationItem.rightBarButtonItem = nil;
                
            });
        }
        
        
    });
    
    dispatch_release(eventsAndNewsQueue);
    
}


- (void)applikationIsBackToForeGround:(id)object{
    NSLog(@"applikationIsBackToForeGround");


    
      [self setupEventsAndNewsTableViews];
    
       [self setUpShadows];
    
       [self downLoadPlaces]; 
    
    //   [self setupPlacesTableView];
    //  [self.placesTableView.tableView reloadData];
    NSLog(@"applikationIsBackToForeGround -------> DONE");

    //Skuggor för vissa element
    
    
}


-(void)downLoadPlaces{    
    
    //Kikar om platerna ska uppdateras och uppdaterar dom om de ska uppdateras.

    if([LastUpdate shouldUpdateLastUpdateDate]){
        
            
        //Sätter en spinner uppe i hörnet
        
        if(self.navigationItem.rightBarButtonItem == nil) {
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [spinner startAnimating];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];        
        }
        
        //Uppdatering av platserna i en egen thread.
        dispatch_queue_t downloadQueue = dispatch_queue_create("Updating Database", NULL);
        
        dispatch_async(downloadQueue, ^{
            
            NSLog(@"Checking Internet for Places");
            if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte uppdatera platsinformation"])
            {
                
                PlacesHandler *placesHandler = [[PlacesHandler alloc] init];
                
                [placesHandler savePlacesToDatabaseContext:[placesHandler getPlacesFromWeb]];
                
                //Tar bort spinnern. Detta måste göras i main_queue() eftersom det rör gränssnittet.
                
                [self setupPlacesTableView];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.placesTableView.tableView reloadData];
                    
                    self.navigationItem.rightBarButtonItem = nil;    
                    
                });
                
            }
            
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //tar bort spinnern om det inte finns internet.
                    self.navigationItem.rightBarButtonItem = nil;
                    
                });
                
                
            }
            
        });
        
        dispatch_release(downloadQueue);
        
        
        
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {  
    
    //Animationen av sliden av sectionViewen när scrollViewen scrollar.
    sectionView.center = CGPointMake(347 - sender.contentOffset.x/3, sectionView.center.y);
    
    //Animationen av textstorleken i sectionViewen. 
    float middleOfInfoSectionView = (sectionView.frame.origin.x);
    float middleOfHomeSectionView = 120 - ABS(sectionView.frame.origin.x);
    float middleOfEventsSectionView =120 -ABS(sectionView.frame.origin.x +120);
    float middleOfNewsSectionView = ABS(sectionView.frame.origin.x)-120;

    // När texten för varje view är i mitten ska middlevärderna vara 120.
    
    homeSection.titleLabel.font =   [UIFont boldSystemFontOfSize: (11 + 5*middleOfHomeSectionView   /120)];
    infoSection.titleLabel.font =   [UIFont boldSystemFontOfSize: (11 + 5*middleOfInfoSectionView   /(120))];
    eventsSection.titleLabel.font = [UIFont boldSystemFontOfSize: (11 + 5*middleOfEventsSectionView /120)];
    newsSection.titleLabel.font =   [UIFont boldSystemFontOfSize: (11 + 5*middleOfNewsSectionView  /120)];

    
}

- (IBAction)scrollScrollViewToStudentInfo:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:YES];
}


- (IBAction)scrollScrollViewToHome:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 480) animated:YES];
    
}


- (IBAction)scrollScrollViewToEvents:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(640, 0, 320, 480) animated:YES];
    
}


- (IBAction)scrollScrollViewToNews:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(960, 0, 320, 480) animated:YES];
    
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"mapSegue"]) 
    {
        
        MapViewController *mapViewController = (MapViewController *) segue.destinationViewController;
        
        NSIndexPath *selectedRowIndex = [self.placesTableView.tableView indexPathForSelectedRow];
        
        mapViewController.initialCategorySortString =  [[[self.placesTableView.fetchedResultsController sections] objectAtIndex:[[self.placesTableView.fetchedResultsController sections] count] - selectedRowIndex.row -1] name];
        
        
    }
    
    else if ([segue.identifier isEqualToString:@"showSchemaSegue"]) 
    {
        WebViewController *webViewController = (WebViewController *) segue.destinationViewController;
        
        NSIndexPath *selectedRowIndex = [schemaTableView.tableView indexPathForSelectedRow];
        
        Schema *schema = [schemaTableView.fetchedResultsController objectAtIndexPath:selectedRowIndex];
        
        webViewController.urlString = schema.url ;
        
    }

    
}


-(void)setUpShadows{
    
    //Parametrar för skuggeffekten för platsfönstret.
    self.placesShadowView.frame = CGRectMake(
                                             self.placesContainerView.frame.origin.x +10,
                                             self.placesContainerView.frame.origin.y+10, 
                                             self.placesContainerView.frame.size.width -15, 
                                             self.placesContainerView.frame.size.height -15);
    
    
    self.placesShadowView.layer.shadowOpacity = 1;
    self.placesShadowView.layer.shadowRadius = 15;
    self.placesShadowView.layer.shadowOffset = CGSizeMake(0, 5);
    self.placesShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.placesShadowView.backgroundColor = [UIColor lightGrayColor];
    
    //Förbättrar prestandan i animeringarna
    self.placesShadowView.layer.shouldRasterize = YES;
    
    
    
    //Parametrar för skuggeffekten på schemafönstret.
    self.schemaShadowView.frame = CGRectMake(
                                             self.schemaTableView.tableView.frame.origin.x +10, 
                                             self.schemaTableView.tableView.frame.origin.y+10, 
                                             self.schemaTableView.tableView.frame.size.width -15, 
                                             self.schemaTableView.tableView.frame.size.height -15);
    
    
    self.schemaShadowView.layer.shadowOpacity = 1;
    self.schemaShadowView.layer.shadowRadius = 15;
    self.schemaShadowView.layer.shadowOffset = CGSizeMake(0, 5);
    self.schemaShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.schemaShadowView.backgroundColor = [UIColor lightGrayColor];
    
    //Förbättrar prestandan i animeringarna
    self.schemaShadowView.layer.shouldRasterize = YES;
    
}


-(void)setUpPlacesContainer
{
    //Ställer in var containern till platslistan är någonstant. Sätter även rundade hörn å en border på containern så att den liknar schemalistan.
    self.placesContainerView.layer.masksToBounds = YES;
    self.placesContainerView.layer.cornerRadius = 10;
    self.placesContainerView.layer.borderWidth = 0.1;
    self.placesContainerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.placesContainerView.frame = CGRectMake(
                                                schemaTableView.tableView.frame.origin.x,
                                                schemaTableView.tableView.frame.origin.y + schemaTableView.tableView.frame.size.height +20,
                                                schemaTableView.tableView.frame.size.width,117);
    
    self.placesTableView.tableView.frame = CGRectMake(
                                                      self.placesContainerView.frame.origin.x+2, 
                                                      self.placesContainerView.frame.origin.y+31, 
                                                      self.placesContainerView.frame.size.width-4, 
                                                      self.placesContainerView.frame.size.height-35);
}

- (IBAction)selfscrollViewscrollRectToVisibleCGRectMake3200320480animatedYESselfscrollViewscrollRectToVisibleCGRectMake3200320480animatedYESscrollScrollViewtoNews:(id)sender {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end