/*
 File: CheckInternetConnection.h
 
 Abstract:  Kikar om internet finns. 
 Slår mot www.google.se och ser om den får repons tillbaks. 
 Annars så visar den en UIAlertView med information om att tillgång till internet inte finns.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */




#import <Foundation/Foundation.h>

@interface CheckInternetConnection : NSObject

+(BOOL)checkInternetConnection: (NSString *)title :(NSString *)message;



@end
