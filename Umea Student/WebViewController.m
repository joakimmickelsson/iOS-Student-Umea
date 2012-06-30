/*
 File: WebViewController.m
 
 Abstract: Visar websidor. Sätt urlString propertyn innan segue eller push till denna viewcontroller så kommer den sidan att laddas i en WebView.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView;
@synthesize urlString;

- (void)viewDidAppear:(BOOL)animated
{

    [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                           
    cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval: 60*60]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.webView.contentMode = UIViewContentModeScaleAspectFit;

    self.navigationItem.rightBarButtonItem = nil;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Kunder inte ladda adressen - Vill du rapportera?");

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
