//
//  MainWriteHomeViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 29/07/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SaveWriteViewController.h"

#import "Opinion.h"

@interface MainWriteHomeViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Opinion *opinion;
@property (strong, nonatomic) NSArray *pickerData;

@property (weak, nonatomic) IBOutlet UITextField *storeName;
@property (weak, nonatomic) IBOutlet UITextView *commentary;
@property (weak, nonatomic) IBOutlet UIPickerView *noteNumber;
@property (weak, nonatomic) IBOutlet UITextField *login;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
