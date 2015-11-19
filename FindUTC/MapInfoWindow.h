//
//  MapInfoWindow.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 09/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapInfoWindow : UIView
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeCategory;
@property (weak, nonatomic) IBOutlet UILabel *storeRate;
@property (weak, nonatomic) IBOutlet UILabel *position;

@end
