/*
 File: WebViewController.h
 
 Abstract: Visar websidor. Sätt urlString propertyn innan segue eller push till denna viewcontroller så kommer den sidan att laddas i en WebView.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "Schema.h"

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong)  NSString *urlString;

@end
