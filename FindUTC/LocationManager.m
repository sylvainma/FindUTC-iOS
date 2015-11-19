//
//  LocationManager.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 22/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "LocationManager.h"
#include <math.h>

#define d2r (M_PI / 180.0)

@implementation LocationManager

+ (double)getDistanceDoubleNumberBetween:(CLLocationCoordinate2D)first and:(CLLocationCoordinate2D)second
{
    //  Source de l'algo: http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates
    
    double lat1 = first.latitude;
    double lat2 = second.latitude;
    double long1 = first.longitude;
    double long2 = second.longitude;
    
    double dlong = (long2 - long1) * d2r;
    
    double dlat = (lat2 - lat1) * d2r;
    double a = pow(sin(dlat/2.0), 2) + cos(lat1*d2r) * cos(lat2*d2r) * pow(sin(dlong/2.0), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = 6367 * c;
    
    return d;
}

+ (NSString*)getDistanceBetween:(CLLocationCoordinate2D)first and:(CLLocationCoordinate2D)second
{
    NSString *distance;
    NSString *unity;
    
    // Calcul numérique de la distance
    double number = [LocationManager getDistanceDoubleNumberBetween:first and:second];
    
    if(number<1)
    {
        number = number*pow(10.0, 3);
        unity = @"m";
    }
    else
    {
        unity = @"km";
    }
    
    // On ne garde que les 3 premiers chiffres de la valeur
    distance = [NSString stringWithFormat:@"%f", number];
    distance = [distance substringToIndex:3];
    
    // On intègre l'unité
    distance = [NSString stringWithFormat:@"%@%@", distance, unity];
    
    return distance;
}

@end
