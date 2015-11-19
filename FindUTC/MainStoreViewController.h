//
//  MainStoreViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StoreTitleCell.h"
#import "StoreInfoCell.h"
#import "StoreInfoCategoryCell.h"
#import "StoreDescriptionCell.h"
#import "StoreButtonCell.h"

#import "OpinionsViewController.h"
#import "MainWriteViewController.h"
#import "StoreMapViewController.h"

#import "Store.h"

@interface MainStoreViewController : UITableViewController

@property (strong, nonatomic) Store *store;

- (void)goToOpinions;
- (void)goToWrite;
- (void)goToMap;

@end
