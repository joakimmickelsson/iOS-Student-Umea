/*
 File: RSS.h
 
 Abstract:  Ett RSSobjekt
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>

@interface RSS : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *pubDate;

@end