/*
 File: CheckInternetConnection.m
 
 Abstract:  Kikar om internet finns. 
 Slår mot www.google.se och ser om den får repons tillbaks. 
 Annars så visar den en UIAlertView med information om att tillgång till internet inte finns.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */


#import "CheckInternetConnection.h"

@implementation CheckInternetConnection

+(BOOL)checkInternetConnection: (NSString *)title :(NSString *)message
{
    NSLog(@"checking internet connection");


    NSError *error = nil;
    
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSASCIIStringEncoding error:&error];
    

    if(!URLString)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        });
        
        
        return NO;
    }
    
    else{
        
        return YES;
    }
}


@end
