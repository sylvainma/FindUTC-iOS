//
//  OpinionCell.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *opinionRate;
@property (weak, nonatomic) IBOutlet UILabel *opinionDate;
@property (weak, nonatomic) IBOutlet UILabel *opinionMessage;

@end
