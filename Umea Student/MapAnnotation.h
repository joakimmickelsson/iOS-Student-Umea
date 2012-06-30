/*
 File: MapAnnotation.h
 
 Abstract: Ett Annotationsobject till MapView.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface MapAnnotation : NSObject <MKAnnotation> {
    
	NSString *title;
    NSString *subtitle;
	CLLocationCoordinate2D coordinate;
    
}
@property (nonatomic,strong) Place *place;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

+(MapAnnotation *)annotationForPlace:(Place *)placeToShow;

@end