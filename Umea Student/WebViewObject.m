/*
 File: WebViewObject.m
 
 Abstract: Detta object innehåller en webview och agerar som dess delegate. 
 
 ladda datat genom att köra dess load:(NSString) metod.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "WebViewObject.h"

@implementation WebViewObject

@synthesize webView;

-(void)load:(NSString *)urlString{
    
    [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: urlString]
                           
                                           cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                       timeoutInterval: 60*60]];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
           
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"scaling");
    
    }

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Kunder inte ladda adressen - Vill du rapportera?");
    
}




@end
