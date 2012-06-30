/*
 File: LastUpdate.h
 
 Abstract:  Ett objekt om håller koll på uppdateringarna av platserna i core data.
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>

@interface LastUpdate : NSObject

@property (nonatomic,strong) NSDate *lastUpdate;


+(NSDate *)getLastUpdate;

+(BOOL)shouldUpdateLastUpdateDate;

+(BOOL)isTheAppRunningForTheFirstTime;
+(BOOL)isTheAppRunningNewVersion;
+(void)upgradeVersion;
+(void)setLastUpdate;

@end
