//
//  API.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 17/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "CoreDataManager.h"

@interface API : NSObject

+ (void)checkApi;
+ (NSString*)getAPIUrl;

+ (NSArray*)getData:(NSString*)theURL;
+ (BOOL)postData:(NSString*)theURL withData:(NSDictionary*)data;
+ (BOOL)postData:(NSString*)theURL withData:(NSDictionary*)data getStatus:(NSString**)status andError:(NSString**)error;

+ (NSString *)URLEncodeStringFromString:(NSString *)string;
+ (NSString*)URLEncode:(NSString*)url;
+ (BOOL)isWifiOn;

@end
