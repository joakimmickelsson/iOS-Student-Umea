/*
 File: SchemaViewController.h
 
 Abstract: Visar scheman som användaren kan välja mellan att spara.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */


#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "Schema.h"
#import "SchemaHandler.h"
#import "CheckInternetConnection.h"

@interface SchemaViewController : TableViewController

@property (nonatomic,strong) SchemaHandler *schemaHandler;

-(void)setupManagedObjectContext;


@end
