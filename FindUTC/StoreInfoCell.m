//
//  StoreInfoCell.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "StoreInfoCell.h"

@implementation StoreInfoCell

@synthesize logo;
@synthesize info;

- (void)awakeFromNib
{
    // Permet d'ajuster la largeur des cellules (évite certains bug d'autolayout des cells)
    info.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-100.0;
    
    [self layoutIfNeeded];
}

- (void)setImageName:(NSString*)imageName
{
    [logo setImage:[UIImage imageNamed:imageName]];
}
@end
