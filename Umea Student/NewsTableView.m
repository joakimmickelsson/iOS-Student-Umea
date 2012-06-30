/*
 File: NewsTableView.m
 
 Abstract: Detta NSObject Hanterar Nyhetslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Hämtar data från Umeå Universitets RSS Kalendarium .
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "NewsTableView.h"

@interface NewsTableView ()

@end

@implementation NewsTableView

-(void)setupNewsTableView{
    self.headerTitle = @"Nyheter";
    [self setupRSSTableView:@"http://www.umu.se/rss/nyheter.rss"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      
    if ([segue.identifier isEqualToString:@"webViewSegue"]) 
    {
        
        WebViewController *webViewController = (WebViewController *) segue.destinationViewController;

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RSS *newsItem = [self.rssOutputData objectAtIndex:indexPath.row];
        
        NSArray *listItems = [newsItem.url componentsSeparatedByString:@"?eventId="];

        webViewController.urlString = [@"http://api.eks.nu/nyheter.php?eventId=" stringByAppendingString:[listItems lastObject]];
        
        
    }
}


@end
