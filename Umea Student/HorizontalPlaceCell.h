/*
 File: HorizontalPlaceCell.h
 
 Abstract: Cellen till sidescrolllistan för platserna i huvudfönstret.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>

@class HorizontalPlaceCell;

@interface HorizontalPlaceCell : UITableViewCell 
{
    IBOutlet UIImageView *typeImage;
    IBOutlet UILabel *typeLabel;

}

@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *typeLabel;

@end
