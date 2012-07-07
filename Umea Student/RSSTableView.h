//
//  RSSTableView.h
//  Umea Student
//
//  Created by Joakim Mickelsson on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RSS.h"
#import "RSSCell.h"
#import "WebViewController.h"
#import "WebViewObject.h"

@interface RSSTableView : NSObject <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong)  RSS *rssObject;

@property(nonatomic,strong)  NSMutableArray *rssOutputData;
@property(nonatomic,strong)  NSString *headerTitle;

@property(nonatomic,strong)  NSMutableString *nodecontent;

@property(nonatomic,strong)  NSXMLParser *xmlParserObject;

@property(nonatomic,strong) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong) IBOutlet UILabel *dateLabel;

@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic,strong) NSString *tableViewIsLoaded;

@property (nonatomic,strong) UITableView *savedTableView;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) RSSCell *cell;

-(void)setupRSSTableView: (NSString *)urlString;
-(void)roundOfCorners;
-(void)stopSpinner;


@end