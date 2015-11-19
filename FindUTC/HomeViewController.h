//
//  HomeViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 06/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "API.h"

@interface HomeViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *buttonSearch;
@property (weak, nonatomic) IBOutlet UIView *buttonFind;
@property (weak, nonatomic) IBOutlet UIView *buttonWrite;

- (IBAction)getInfo:(id)sender;

@end
