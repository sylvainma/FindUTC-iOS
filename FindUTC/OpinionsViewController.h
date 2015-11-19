//
//  OpinionsViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StoreTitleCell.h"
#import "OpinionCell.h"
#import "StoreButtonCell.h"

#import "Store.h"
#import "Opinion.h"

#import "MBProgressHUD.h"

@interface OpinionsViewController : UITableViewController

@property (strong, nonatomic) Store *store;

- (void)moreOpinions;

@end
