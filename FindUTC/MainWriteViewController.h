//
//  MainWriteViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SaveWriteViewController.h"

#import "Store.h"
#import "Opinion.h"

@interface MainWriteViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Store *store;
@property (strong, nonatomic) Opinion *opinion;
@property (strong, nonatomic) NSArray *pickerData;

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIPickerView *note;
@property (weak, nonatomic) IBOutlet UITextField *login;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
