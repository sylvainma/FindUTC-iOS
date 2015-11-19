//
//  MainMapViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 07/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

#import "MainStoreViewController.h"

#import "MVSelectorScrollView.h"
#import "MapInfoWindow.h"

#import "Store.h"
#import "StoreCategory.h"

#import "GoogleMapsManager.h"
#import "LocationManager.h"

@interface MainMapViewController : UIViewController <MVSelectorScrollViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet MVSelectorScrollView *scollView;

@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
