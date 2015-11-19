//
//  Store.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 17/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "API.h"
#import "CoreDataManager.h"

@interface Store : NSObject

@property (strong, readwrite) NSString *idStore;
@property (strong, readwrite) NSString *idCategory;
@property (strong, readwrite) NSString *nameCategory;
@property (strong, readwrite) NSString *name;
@property (strong, readwrite) NSString *adress;
@property (strong, readwrite) NSString *phone;
@property (strong, readwrite) NSString *hours;
@property (strong, readwrite) NSString *desc;
@property (strong, readwrite) NSString *rate;
@property (strong, readwrite) NSString *nbOpinions;
@property (strong, readwrite) NSString *lat;
@property (strong, readwrite) NSString *lng;

+ (id)getStoreByID:(NSString*)theIDStore;
+ (id)getAllStoresByCategory:(NSString*)idCategory;

@end
