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

- (void)viewDidLoad {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadMainViewComponents:) 
                                                 name:@"AppEnteredForeground" 
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{

     if([LastUpdate isTheAppRunningForTheFirstTime]){
         NSLog(@"first is the apprunningfor the first time");
         
         [self loadMainViewComponents:nil];
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

         [defaults setBool:NO forKey:@"studentAppFirstTimeUse"];
                  
         [defaults synchronize];
     }
    
    if([LastUpdate isTheAppRunningNewVersion] ){
        NSLog(@"New version");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [LastUpdate upgradeVersion];
        
        [defaults synchronize];
     
        [self loadMainViewComponents:nil];
         
     }
    
}


-(void)viewWillAppear:(BOOL)animated{

    [self setupSchemaTableView];
    

    [self setupPlacesTableView];
    [self setUpShadows];
}


//Laddar platslistan med platserna om det finns platser i databasen.
//Scrollar listan till början (egentligen slutet på listan, men listan är snedvriden så första elementet blir egentligen det sista.

-(void)setupPlacesTableView{
    NSLog(@"setupplaces");

    [self.placesTableView setUpPlacesTableView];
    [self setUpPlacesContainer];
    
    if([[self.placesTableView.fetchedResultsController sections] count] > 0) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[[self.placesTableView.fetchedResultsController sections] count] -1 inSection:0];
        
        [self.placesTableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        NSLog(@"fetched stämmer");
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

    //Lägger till en spinner för nedladdningen.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    
    NSLog(@"downloading eventsand news");
    dispatch_queue_t eventsAndNewsQueue = dispatch_queue_create("Downloading Events and News", NULL);
    
    dispatch_async(eventsAndNewsQueue, ^{
        
        //Ställer in evenemang och nyhetstableviewna om internet finns flr att hämta rss data.
        NSLog(@"before");

        if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte hämta evenemang och nyheter"])
        {
            
            NSLog(@"after");

            if(![self.eventsTableView.tableViewIsLoaded isEqualToString:@"YES"]){
                
                [self.eventsTableView setUpEventsTableView];
                
                self.eventsTableView.tableViewIsLoaded = @"YES";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.eventsTableView.tableView reloadData];
                    
                    
                });
                
                
            }
            
            if(![self.newsTableView.tableViewIsLoaded isEqualToString:@"YES"]){
                
                [self.newsTableView setUpNewsTableView];    
                
                self.newsTableView.tableViewIsLoaded = @"YES";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
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


- (void)loadMainViewComponents:(id)object{
    
    //Ställer in appens huvudfönster
    [scrollView setContentSize:CGSizeMake(960,scrollView.frame.size.height)];

    
    //Scrolla scrollviewen till hemskärmen.
    [self.scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 480) animated:NO];

    self.scrollView.pagingEnabled = YES;
    
    [self setupEventsAndNewsTableViews];
    
    [self setUpShadows];

    [self downLoadPlaces]; 

    [self setupPlacesTableView];
        [self.placesTableView.tableView reloadData];

    //Skuggor för vissa element
        

}


-(void)downLoadPlaces{    
    
    //Kikar om platerna ska uppdateras och uppdaterar dom om de ska uppdateras.
    if([LastUpdate shouldUpdateLastUpdateDate]){
        
        
        NSLog(@"lshould update");

        //Sätter en spinner uppe i hörnet
        
        if(self.navigationItem.rightBarButtonItem == nil) {
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [spinner startAnimating];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];        
        }
        
        //Uppdatering av platserna i en egen thread.
        dispatch_queue_t downloadQueue = dispatch_queue_create("Updating Database", NULL);
        
        dispatch_async(downloadQueue, ^{
            
            if([CheckInternetConnection checkInternetConnection:@"Inget Internet" :@"Kan inte uppdatera platsinformation"])
            {
                
                PlacesHandler *placesHandler = [[PlacesHandler alloc] init];
                
                [placesHandler savePlacesToDatabaseContext:[placesHandler getPlacesFromWeb]];
                NSLog(@"places saved");

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
        

        
        [LastUpdate setLastUpdate];
        
    }
    
    else{
        
        NSLog(@"no update required");
        
        
    }
    


}

- (void)scrollViewDidScroll:(UIScrollView *)sender {  
    
    //Animationen av sliden av sectionViewen när scrollViewen scrollar.
    sectionView.center = CGPointMake(267 - sender.contentOffset.x/3, sectionView.center.y);
    
    
    //Animationen av textstorleken i sectionViewen. 
    float middleOfHomeSectionView = 106.5 - ABS(sectionView.frame.origin.x);
    float middleOfEventsSectionView = (sectionView.frame.origin.x);
    float middleOfNewsSectionView = ABS(sectionView.frame.origin.x -106.5) -106.5 ;
    
    homeSection.titleLabel.font = [UIFont boldSystemFontOfSize: (11 + 5*middleOfHomeSectionView/106.5)];
    eventsSection.titleLabel.font = [UIFont boldSystemFontOfSize: (11 + 5*middleOfEventsSectionView/(106.5))];
    infoSection.titleLabel.font = [UIFont boldSystemFontOfSize: (11 + 5*middleOfNewsSectionView/106.5)];
    
}

- (IBAction)scrollScrollViewToEvents:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:YES];
}


- (IBAction)scrollScrollViewToHome:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 480) animated:YES];
    
}


- (IBAction)scrollScrollViewToNews:(id)sender{
    
    [self.scrollView scrollRectToVisible:CGRectMake(640, 0, 320, 480) animated:YES];
    
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
    
    else if ([segue.identifier isEqualToString:@"fromEventsToWebViewSegue"]) 
    {
        
        WebViewController *webViewController = (WebViewController *) segue.destinationViewController;
        
        
        NSIndexPath *indexPath = [self.eventsTableView.tableView indexPathForSelectedRow];
        
        RSS *newsItem = [self.eventsTableView.rssOutputData objectAtIndex:indexPath.row];
        
        NSArray *listItems = [newsItem.url componentsSeparatedByString:@"?eventId="];
        
        
        NSLog(@"%@",[listItems lastObject]);
        
        webViewController.urlString = [@"http://api.eks.nu/evenemang.php?eventId=" stringByAppendingString:[listItems lastObject]];
        
        NSLog(@"%@",webViewController.urlString);
        
    }
    
    else if ([segue.identifier isEqualToString:@"fromNewsToWebViewSegue"]) 
    {
        
        WebViewController *webViewController = (WebViewController *) segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.newsTableView.tableView indexPathForSelectedRow];
        
        RSS *newsItem = [self.newsTableView.rssOutputData objectAtIndex:indexPath.row];
        
        NSArray *listItems = [newsItem.url componentsSeparatedByString:@"?eventId="];
        
        webViewController.urlString = [@"http://api.eks.nu/nyheter.php?eventId=" stringByAppendingString:[listItems lastObject]];
        
        
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