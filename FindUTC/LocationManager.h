//
//  LocationManager.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 22/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (double)getDistanceDoubleNumberBetween:(CLLocationCoordinate2D)first and:(CLLocationCoordinate2D)second;
+ (NSString*)getDistanceBetween:(CLLocationCoordinate2D)first and:(CLLocationCoordinate2D)second;

@end
