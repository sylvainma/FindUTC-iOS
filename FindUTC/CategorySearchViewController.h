//
//  CategorySearchViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategorySearchResultsViewController.h"
#import "MainStoreViewController.h"
#import "StoreCell.h"

#import "Store.h"
#import "StoreCategory.h"

#import "MBProgressHUD.h"

@interface CategorySearchViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, strong) StoreCategory *category;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
