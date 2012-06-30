/*
 File: PlacesSearchViewController.h
 
 Abstract:  Applikationens Sökvy för platser. Från förstoringsglaset på Mapview.
 Sorterar platserna efter den kategori som klickades på i huvudfönstret.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "MapViewController.h"

@interface PlacesSearchViewController : TableViewController

@property (nonatomic,strong) NSString *initialCategorySortString;

@end
