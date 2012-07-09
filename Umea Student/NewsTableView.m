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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    RSS *rss = [self.rssOutputData objectAtIndex:indexPath.row];
    
    NSArray *listItems = [rss.url componentsSeparatedByString:@"?eventId="];
    
    
    [self setupwebView: [@"http://api.eks.nu/nyheter.php?eventId=" stringByAppendingString:[listItems lastObject]]];
    
    
    [self flipToView:self.tableView.superview :self.webView];
    
}



@end
