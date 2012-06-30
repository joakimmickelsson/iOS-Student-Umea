/*
 File: MainViewController.h
 
 Abstract: Huvudfönstret i appen. Denna ställer in alla olika views som visas i huvudfönstret samt uppdaterar alla platser från hitta.db. 
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PlacesHandler.h"
#import "Schema.h"
#import "SchemaTableView.h"
#import "PlacesTableView.h"
#import "WebViewController.h"
#import "FetchRequest.h"
#import "MapViewController.h"
#import "CheckInternetConnection.h"
#import "LastUpdate.h"
#import "EventsTableView.h"
#import "NewsTableView.h"
#import "WebViewObject.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;

//Titeln som användaren scrollar till
@property (nonatomic,strong) IBOutlet UIView *sectionView;

@property (nonatomic,strong) IBOutlet UIButton *infoSection;
@property (nonatomic,strong) IBOutlet UIButton *homeSection;
@property (nonatomic,strong) IBOutlet UIButton *eventsSection;
@property (nonatomic,strong) IBOutlet UIButton *newsSection;

@property (nonatomic,strong) IBOutlet WebViewObject *studentInfoWebView;

@property (nonatomic,strong) IBOutlet SchemaTableView *schemaTableView;
@property (nonatomic,strong) IBOutlet UIView *schemaShadowView;

@property (nonatomic,strong) IBOutlet UIView *placesContainerView;
@property (nonatomic,strong) IBOutlet PlacesTableView *placesTableView;
@property (nonatomic,strong) IBOutlet UIView *placesShadowView;

@property (nonatomic,strong) IBOutlet EventsTableView *eventsTableView;
@property (nonatomic,strong) IBOutlet NewsTableView *newsTableView;



-(void)setUpPlacesContainer;
-(void)setUpShadows;
-(void)loadMainViewComponents:(id)object;
-(void)downLoadPlaces;
-(void)setupPlacesTableView;
-(void)setupSchemaTableView;
-(void)setupEventsAndNewsTableViews;

- (IBAction)scrollScrollViewToEvents:(id)sender;
- (IBAction)scrollScrollViewToHome:(id)sender;
- (IBAction)scrollScrollViewToNews:(id)sender;

@end
