/*
 File: LastUpdate.m
 
 Abstract:  Ett objekt om håller koll på uppdateringarna av platserna i core data.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "LastUpdate.h"
#import "AppDelegate.h"

@implementation LastUpdate

@synthesize lastUpdate;

//Hämtar datumet för senaste uppdateringen och returnerar det.

+(NSDate *)getLastUpdate
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *studentAppPlacesLastUpdateDate = [defaults objectForKey:@"studentAppPlacesLastUpdateDate"];

    return studentAppPlacesLastUpdateDate;
}

+(void)upgradeVersion{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *CurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    
    [defaults setObject:CurrentVersion forKey:@"studentAppVersion"];
    
    [defaults synchronize];

}

+(BOOL)isTheAppRunningNewVersion{
    NSLog(@"checking New version");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *appVersion = [defaults stringForKey:@"studentAppVersion"];
    
    NSString *CurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];    
    
    if([appVersion compare:CurrentVersion] != 0)
    {
        NSLog(@"New version: YES");

        return YES;
    }    
    
    else {
        NSLog(@"New version: NO");

        
        return NO;
        
}

}

+(BOOL)isTheAppRunningForTheFirstTime{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *appVersion = [defaults stringForKey:@"studentAppFirstTimeUse"];
    
    
    if(appVersion == nil) 
    {
        NSLog(@"App Runs For First Time");
        [self upgradeVersion]; 
        return YES;
    }
    
    else {
        return NO;
    
    }

}
    
    
//Kikar om platserna ska uppdateras 
+(BOOL)shouldUpdateLastUpdateDate{
    NSLog(@"Checking LastUpdate");

    NSDate *lastPlacesUpdateDate = [self getLastUpdate];
    

    if( lastPlacesUpdateDate == nil) 
    {

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[NSDate date] forKey:@"studentAppPlacesLastUpdateDate"];

        [defaults synchronize];

        NSLog(@"Shouldupdate: YES");

        return YES;
    }
    else{
    
        //Kikar om senaste uppdatering var mer än 7 dagar sedan. Isåfall uppdaterar den platserna.
        
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate: lastPlacesUpdateDate];

        
        if(interval > 60*60*24*7){

            NSLog(@"Shouldupdate: YES");

            return YES;
        }
    
        NSLog(@"Shouldupdate: NO");

        return NO;

        }
}

//Sparar senaste datumet i core data som applikationens platser uppdaterades.
+(void)setLastUpdate
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
    [defaults setObject:[NSDate date] forKey:@"studentAppPlacesLastUpdateDate"];
    
    [defaults synchronize];        
}


@end