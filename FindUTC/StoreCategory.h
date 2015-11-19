//
//  StoreCategory.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 21/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "API.h"
#import "CoreDataManager.h"

@interface StoreCategory : NSObject

@property (strong, nonatomic) NSString *idCategory;
@property (strong, nonatomic) NSString *nameCategory;
@property (strong, nonatomic) NSString *nameCategoryPlural;
@property (strong, nonatomic) NSString *nbStores;

+ (NSMutableArray*)getAllCategories;

@end
