/*
 File: MapViewController.h
 
 Abstract:  Applikationens Kartvy. Hämtar object från core data och visar dessa. 
            Har även stöd för GPS.
            Kan visa antingen kategorivis eller ett enskilt object.
            (Sätt så place propertyn innan denna view pushas.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "Place.h"
#import "MapAnnotation.h"
#import "HorizontalPlaceCell.h"
#import "TableViewController.h"
#import "PlacesSearchViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic,strong) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) Place *place;
@property (nonatomic,strong) NSString *initialCategorySortString;
@property (nonatomic,strong) NSArray *annotations;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) NSString *backFromPlacesList;

@end
