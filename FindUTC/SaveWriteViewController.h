//
//  SaveWriteViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Opinion.h"

@interface SaveWriteViewController : UIViewController

@property (strong, nonatomic) Opinion *opinion;

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UILabel *message;

- (IBAction)okButton:(id)sender;

@end
