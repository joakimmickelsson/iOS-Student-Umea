/*
 File: NewsTableView.h
 
 Abstract: Detta NSObject Hanterar Nyhetslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Hämtar data från Umeå Universitets RSS Kalendarium .
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "RSS.h"
#import "RSSCell.h"
#import "WebViewController.h"

@interface NewsTableView : NSObject  <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong)  RSS *newsObject;

@property(nonatomic,strong)  NSMutableArray *rssOutputData;

@property(nonatomic,strong)  NSMutableString *nodecontent;

@property(nonatomic,strong)  NSXMLParser *xmlParserObject;

@property(nonatomic,strong) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong) IBOutlet UILabel *dateLabel;

@property (nonatomic,strong) RSSCell *cell;

@property (nonatomic,strong) NSString *tableViewIsLoaded;

-(void)setUpNewsTableView;

@end