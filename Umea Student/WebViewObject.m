/*
 File: WebViewObject.m
 
 Abstract: Detta object innehåller en webview och agerar som dess delegate. 
 
 ladda datat genom att köra dess load:(NSString) metod.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "WebViewObject.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebViewObject

@synthesize webView;

-(void)load:(NSString *)urlString{
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = YES;
    
    [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: urlString]
                           
                                           cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                       timeoutInterval: 60*60]];
    

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
           
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished Loading Student Info");
    
    NSLog(@"zooming");
    //zooms content to fit thw webview
    if ([self.webView respondsToSelector:@selector(scrollView)])
    {
        UIScrollView *scroll=[self.webView scrollView];
        
        float zoom=self.webView.bounds.size.width/scroll.contentSize.width;
        [scroll setZoomScale:zoom animated:YES];
    }
    
    }

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [[[UIAlertView alloc]initWithTitle:@"Inget internet" message:@"Ahh vilken otur... försök igen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    NSLog(@"Kunder inte ladda adressen - Vill du rapportera?");
    
}

-(void)roundOfCorners{
    // self.webView.layer.cornerRadius = 10;
    //  self.webView.layer.borderWidth = 0.1;
    // self.webView.layer.borderColor = [UIColor blackColor].CGColor;
    
}


@end
