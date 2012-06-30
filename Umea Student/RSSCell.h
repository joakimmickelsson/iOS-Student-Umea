/*
 File: RSSCell.h
 
 Abstract:  TableViewCellen i evenemang och nyhetslistorna på huvudfönstret.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>

@interface RSSCell : UITableViewCell


@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,strong) IBOutlet UILabel *dateLabel;

@end
