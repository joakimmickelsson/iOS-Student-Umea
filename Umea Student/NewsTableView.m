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



-(IBAction)flipBackFromWebView:(id)sender{
    
    UIView *webView = [sender superview];
    
    
    [self flipToView:webView.superview :self.savedTableView];
    
}

-(void)flipToView:(UIView *)parentContainer :(UIView *)to{
    
    to.layer.masksToBounds = YES;
    to.layer.cornerRadius = 10;
    to.layer.borderWidth = 0.1;
    to.layer.borderColor = [UIColor blackColor].CGColor;
    
    [UIView transitionWithView:parentContainer duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft //change to whatever animation you like
                    animations:^ { 
                        
                        
                        
                        [parentContainer addSubview:to]; 
                        
                        
                    }
                    completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.tableView.frame];
    
    RSS *rss = [self.rssOutputData objectAtIndex:indexPath.row];
    
    self.savedTableView = self.tableView;
    
    NSArray *listItems = [rss.url componentsSeparatedByString:@"?eventId="];
    
    [webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: [@"http://api.eks.nu/nyheter.php?eventId=" stringByAppendingString:[listItems lastObject]]]
                          
                                          cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                      timeoutInterval: 60*60] ];
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(flipBackFromWebView:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setFrame:CGRectMake(webView.frame.size.width-32, 0, 32, 32)];
    
    
    [webView addSubview:button];
    
    
    [self flipToView:self.tableView.superview :webView];
    
    
    [self.tableView removeFromSuperview];
    
}



@end
