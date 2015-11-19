//
//  StoreButtonCell.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "StoreButtonCell.h"

@implementation StoreButtonCell

@synthesize button;

- (void)setButtonTitle:(NSString *)title
{
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
