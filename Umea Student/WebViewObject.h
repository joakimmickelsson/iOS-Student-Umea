/*
 File: WebViewObject.h
 
 Abstract: Detta object innehåller en webview och agerar som dess delegate. 
 
 ladda datat genom att köra dess load:(NSString) metod.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>

@interface WebViewObject : NSObject <UIWebViewDelegate>

@property (nonatomic,strong) IBOutlet UIWebView *webView;

-(void)load:(NSString *)urlString;

@end
