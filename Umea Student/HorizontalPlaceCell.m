/*
 File: HorizontalPlaceCell.m
 
 Abstract: Cellen till sidescrolllistan för platserna i huvudfönstret.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "HorizontalPlaceCell.h"

@implementation HorizontalPlaceCell

@synthesize typeImage = _typeImage;
@synthesize typeLabel = _typeLabel;

/*
- (id)initWithFrame:(CGRect)frame
{    
    
    self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2)] ;
    self.thumbnail.opaque = YES;
    
    [self.contentView addSubview:self.thumbnail];
    
    self.titleLabel = [[ArticleTitleLabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height * 0.632, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.37)] ;
    self.titleLabel.opaque = YES;
    
  //  [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    self.titleLabel.numberOfLines = 2;
    [self.thumbnail addSubview:self.titleLabel];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbnail.frame] ;
    self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
    
  //  self.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    return self;
}
*/

#pragma mark - View Lifecycle

- (NSString *)reuseIdentifier 
{
    return @"categoryCell";
}

#pragma mark - Memory Management

- (void)dealloc
{
    self.typeImage = nil;
    self.typeLabel = nil;
    }

@end
