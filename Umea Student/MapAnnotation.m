/*
 File: MapAnnotation.m
 
 Abstract: Ett Annotationsobject till MapView.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title, subtitle;
@synthesize coordinate;
@synthesize place;

+(MapAnnotation *)annotationForPlace:(Place *)placeToShow
{
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
    
    CLLocationCoordinate2D placeCoordinate;
    placeCoordinate.longitude = 20.305937; // set these var's first!
    placeCoordinate.latitude = 63.820061;
    
    placeCoordinate.latitude = [placeToShow.latitude doubleValue];
    placeCoordinate.longitude = [placeToShow.longitude doubleValue];


    annotation.coordinate = placeCoordinate; 

    annotation.title = placeToShow.name;
    annotation.subtitle = placeToShow.type;
    
    return annotation;
} 



@end