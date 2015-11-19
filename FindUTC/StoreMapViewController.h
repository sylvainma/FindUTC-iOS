//
//  StoreMapViewController.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 09/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

#import "MapInfoWindowMin.h"

#import "GoogleMapsManager.h"
#import "LocationManager.h"

#import "Store.h"

@interface StoreMapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) Store *store;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)close:(id)sender;

@end
