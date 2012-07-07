/*
 File: MapViewController.m
 
 Abstract:  Applikationens Kartvy. Hämtar object från core data och visar dessa. 
            Har även stöd för GPS.
            Kan visa antingen kategorivis eller ett enskilt object.
            (Sätt så place propertyn innan denna view pushas.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */


#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize place;
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize initialCategorySortString;
@synthesize backFromPlacesList;

-(IBAction)pushBack:(id)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



-(void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) 
    {
        [self.mapView addAnnotations:self.annotations];
    }
    
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}


-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}


-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    if(![backFromPlacesList isEqualToString:@"YES"]){


    MKCoordinateRegion regionToShowOnMap;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta=0.010; 
    coordinateSpan.longitudeDelta=0.010; 
    regionToShowOnMap.span=coordinateSpan;
    
    CLLocationCoordinate2D location;
    location.longitude = 20.305937; // set these var's first!
    location.latitude = 63.820061;
    
    regionToShowOnMap.center=location;

    [_mapView setRegion:regionToShowOnMap animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated{

    if(![backFromPlacesList isEqualToString:@"YES"]){
    if(place){
        NSLog(@"if place");
        MapAnnotation *mapAnnotation = [MapAnnotation annotationForPlace: place ];
        
        [self setAnnotations:[[NSArray alloc] initWithObjects:mapAnnotation,nil]];
        
        MKCoordinateRegion regionToShowOnMap;
        MKCoordinateSpan coordinateSpan;
        coordinateSpan.latitudeDelta=0.010; 
        coordinateSpan.longitudeDelta=0.010; 
        regionToShowOnMap.span=coordinateSpan;
        
        CLLocationCoordinate2D location;
        location.longitude = [place.longitude doubleValue]; // set these var's first!
        location.latitude = [place.latitude doubleValue];
        
        regionToShowOnMap.center=location;
        
        [_mapView setRegion:regionToShowOnMap animated:YES];
        

    }
    
    else if(initialCategorySortString) {

        NSLog(@"if initialstring"); 
        self.managedObjectContext = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
        
        NSSortDescriptor *sortDescriptor1 = 
        [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
        
        NSSortDescriptor *sortDescriptor2 = 
        [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil];      
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@",initialCategorySortString];
        
        [self searchDataBase: [FetchRequest setupFetchRequest:@"Place" :predicate :sortDescriptors :self.managedObjectContext] :@"type" :nil];    
        
        [self createAnnotationsFromPlaces:self.fetchedResultsController.fetchedObjects];
                

    }
        
    }
  
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
    
}


-(void)createAnnotationsFromPlaces:(NSArray *)placesArray{
    
    
    NSMutableArray *annotationsarray = [[NSMutableArray alloc] init];
    
    for (Place *placedata in placesArray){
        
        [annotationsarray addObject:[MapAnnotation annotationForPlace:placedata]];
    }
    
    [self setAnnotations: annotationsarray];
    
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    
    for (MKAnnotationView *annotationView in annotationViews)
    {
        CGRect endFrame = annotationView.frame;
        annotationView.frame = CGRectOffset(endFrame, 0, -200);
        
        [UIView animateWithDuration:0.150 
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction 
                         animations:^{ annotationView.frame = endFrame; } 
                         completion:NULL];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"platserSearchListSegue"]) {
        
        PlacesSearchViewController *placesSearchViewController = (PlacesSearchViewController *) segue.destinationViewController;
        
        Place *placeToRecognizeType = [[self.fetchedResultsController fetchedObjects] lastObject];
        
        placesSearchViewController.initialCategorySortString = placeToRecognizeType.type;
        
        if([backFromPlacesList isEqualToString:@"YES"]){
            
            placesSearchViewController.initialCategorySortString = nil;            
        }
        
        backFromPlacesList = @"YES";

    }
    
}





@end
