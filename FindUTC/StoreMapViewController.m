//
//  StoreMapViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 09/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "StoreMapViewController.h"

@interface StoreMapViewController ()

@end

@implementation StoreMapViewController

@synthesize store;
@synthesize mapView;

@synthesize userLocation;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    //  Réglages pour la position de l'user
    //
    
    // Initialisation
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // Demande à l'utilisateur d'utiliser ses données de localisation pendant l'éxecution uniquement
    [locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        // Précision souhaitée (abaisser pour préserver la batterie)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 100 mètres déplacement avant l'appel d'Update
        locationManager.distanceFilter = 100.0f;
        
        // On commence à suivre la localisation
        [locationManager startUpdatingLocation];
        NSLog(@"Location: StartUpdatingLocation");
    }
    else
    {
        NSLog(@"Location: !locationServicesEnabled");
    }
    
    //
    // Positionnement provisoire de la carte sur Compiègne
    //
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.417806
                                                            longitude:2.825926
                                                                 zoom:14];
    mapView.camera = camera;
    
    // Bouttons (localisation&rotation)
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    
    // MyLocation
    mapView.myLocationEnabled = YES;
    
    // Delegate
    mapView.delegate = self;
    
    /*
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.417806
                                                            longitude:2.825926
                                                                 zoom:14];
    mapView.camera = camera;
    
    // Bouttons (localisation&rotation)
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    
    // MyLocation
    mapView.myLocationEnabled = YES;
    
    // Delegate
    mapView.delegate = self;
    
    //
    // Placement de marker
    //
    
    [GoogleMapsManager setUpMarkersWithStores:@[store] onMap:mapView];
    */
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //
    // Paramétrisation de la map
    //
    
    // Création de l'objet coordonnées
    NSDictionary *location = @{@"latitude" : store.lat,
                               @"longitude" : store.lng};
    
    CLLocationCoordinate2D coord = [GoogleMapsManager getCoordinateFromLocation:location];
    
    // Repositionnement de la camera
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithLatitude:coord.latitude
                                                               longitude:coord.longitude
                                                                    zoom:14];
    mapView.camera = newCamera;
    
    // Positionnement du marker
    [GoogleMapsManager setUpMarkerWithStore:store andLocation:location onMap:mapView];
    
    // Recherche de ses coordonnées GPS à partir de son adresse postale, puis affichage
    /*
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:store.adress
                 completionHandler:^(NSArray* placemarks, NSError* error)
     {
         // objectAtIndex:0 est le résultat le plus probant
         CLPlacemark *thePlacemark = [placemarks objectAtIndex:0];
         
         // Création de l'objet coordonnées
         NSDictionary *location = @{@"latitude" : [NSString stringWithFormat:@"%f",
                                                [thePlacemark location].coordinate.latitude],
                                 @"longitude" : [NSString stringWithFormat:@"%f",
                                                 [thePlacemark location].coordinate.longitude]};
         
         CLLocationCoordinate2D coord = [GoogleMapsManager getCoordinateFromLocation:location];
         
         // Repositionnement de la camera
         GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithLatitude:coord.latitude
                                                                 longitude:coord.longitude
                                                                      zoom:14];
         mapView.camera = newCamera;
         
         // Positionnement du marker
         [GoogleMapsManager setUpMarkerWithStore:store andLocation:location onMap:mapView];
         
     }];
    */
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Google Maps

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    MapInfoWindowMin *infoWindowMin = [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindowMin" owner:self options:nil] objectAtIndex:0];
    
    Store *theStore = marker.userData;
    infoWindowMin.storeName.text = theStore.name;
    infoWindowMin.storeCategory.text = theStore.nameCategory;
    infoWindowMin.storeRate.text = [NSString stringWithFormat:@"%@ (%@ avis)", theStore.rate, theStore.nbOpinions];
    
    if(userLocation!=nil)
        infoWindowMin.position.text = [LocationManager getDistanceBetween:userLocation.coordinate and:marker.position];
    else
        infoWindowMin.position.text = @"";
    
    return infoWindowMin;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    userLocation = newLocation;
    NSLog(@"Location: Update de la position du device");
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Location: Erreur de l'update de la position du device");
}

@end
