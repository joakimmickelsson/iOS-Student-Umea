/*
 File: EventsTableView.h
 
 Abstract: Detta NSObject Hanterar Evenemangslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Hämtar data från Umeå Universitets RSS Kalendarium .
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "RSSTableView.h"


@interface EventsTableView : RSSTableView <UITableViewDelegate>

-(void)setupEventsTableView;

@property(nonatomic,strong) IBOutlet UIWebView *webView;

@end