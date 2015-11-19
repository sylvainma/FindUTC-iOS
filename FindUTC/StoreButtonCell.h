//
//  StoreButtonCell.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textButton;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (void)setButtonTitle:(NSString*)title;

@end
