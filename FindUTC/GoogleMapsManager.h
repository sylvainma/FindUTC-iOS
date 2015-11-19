//
//  GoogleMapsManager.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 22/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

#import "Store.h"

@interface GoogleMapsManager : NSObject

+ (GMSMapView*)initMapWithLocation:(NSDictionary*)location andZoom:(double)zoom;
+ (GMSMapView*)initMapOnMarkerWithStore:(Store*)store andLocation:(NSDictionary*)location;
+ (void)setUpMarkerWithStore:(Store*)store andLocation:(NSDictionary*)location onMap:(GMSMapView*)map;
+ (void)setUpMarkersWithStores:(NSArray*)allStores onMap:(GMSMapView*)map;
+ (CLLocationCoordinate2D)getCoordinateFromLocation:(NSDictionary*)location;

@end
