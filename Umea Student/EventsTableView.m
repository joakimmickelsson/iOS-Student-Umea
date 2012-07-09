/*
 File: EventsTableView.m
 
 Abstract: Detta NSObject Hanterar Evenemangslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Hämtar data från Umeå Universitets RSS Kalendarium .
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "EventsTableView.h"

@interface EventsTableView ()

@end

@implementation EventsTableView

@synthesize webView;

-(void)setupEventsTableView{
    
    self.headerTitle = @"Evenemang";
    
    [self setupRSSTableView:@"http://www.umu.se/om-universitetet/aktuellt/kalendarium/rss/kalender-rss/?categories=concert,conference,courseEducation,culturOnCampus,dissertation,exhibition,lecture,licentiateSeminar,meeting,theOthers,seminar,seminarSeries,umea2014,workshop&calendarIds=32&fromSiteNodeId=39132"];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    


    
    RSS *rss = [self.rssOutputData objectAtIndex:indexPath.row];
    
    NSArray *listItems = [rss.url componentsSeparatedByString:@"?eventId="];
    
   
    
    [self setupwebView: [@"http://api.eks.nu/evenemang.php?eventId=" stringByAppendingString:[listItems lastObject]]];
    
    
    [self flipToView:self.tableView.superview :webView];
    
}


@end
