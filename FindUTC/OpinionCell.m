//
//  OpinionCell.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "OpinionCell.h"

@implementation OpinionCell

@synthesize opinionDate, opinionMessage, opinionRate;

- (void)awakeFromNib
{
    opinionRate.numberOfLines = 0;
    opinionDate.numberOfLines = 0;
    opinionMessage.numberOfLines = 0;

    // Permet d'ajuster la largeur des cellules (évite certains bug d'autolayout des cells)
    opinionMessage.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-50.0;
    
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
