//
//  MainSearchViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 07/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategorySearchViewController.h"

#import "CategoryCell.h"

#import "StoreCategory.h"

#import "MBProgressHUD.h"

@interface MainSearchViewController : UITableViewController

- (UIImage*)getImageFromNameCategory:(NSString*)nameCategory;

@end
