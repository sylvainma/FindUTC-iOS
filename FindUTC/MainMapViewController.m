//
//  MainMapViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 07/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "MainMapViewController.h"

@interface MainMapViewController ()
{
    NSMutableArray *allCategories;
    NSMutableArray *allStores;
}
@end

@implementation MainMapViewController

@synthesize mapView;
@synthesize scollView;

@synthesize userLocation;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    //  Récupération des catégories
    //
    
    allCategories = [StoreCategory getAllCategories];
    NSMutableArray *namesCategories = [[NSMutableArray alloc] init];
    
    if(allCategories!=nil && allCategories.count>=1)
    {
        StoreCategory *tous = [[StoreCategory alloc] init];
        tous.idCategory = @"0";
        tous.nameCategory = @"Tous";
        tous.nameCategoryPlural = @"Tous";
        [allCategories insertObject:tous atIndex:0];
        
        for(int i=0; i<allCategories.count; i++)
        {
            StoreCategory *category = [allCategories objectAtIndex:i];
            [namesCategories addObject:category.nameCategoryPlural];
        }
    }
    
    //
    //  Récupération des Stores
    //
    
    allStores = [Store getAllStoresByCategory:@"0"]; // 0 correspond aux stores toutes catégories
    
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
    //  Configuration de la Map et du scroll de catégorie
    //
    
    // Sélection des catégories
    self.scollView.values = namesCategories;
    self.scollView.delegate = self;
    self.scollView.updateIndexWhileScrolling = YES;
    [self.scollView setSelectedIndex:0 animated:NO];
    
    // Paramétrisation de la map sur Compiègne centre
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
    // Placement des markers catégories Tous
    //
    
    [GoogleMapsManager setUpMarkersWithStores:allStores onMap:mapView];
    
}

#pragma mark - MVSelectorScrollView delegate: méthode appelée à chaque nouvelle sélection

- (void)scrollView:(MVSelectorScrollView *)scrollView pageSelected:(NSInteger)pageSelected
{
    StoreCategory *category = [allCategories objectAtIndex:pageSelected];
    
    // Debugging
    /*
    NSLog(@"Valeur: %@", [scollView.values objectAtIndex:pageSelected]);
    NSLog(@"pageSelected: %ld", (long)pageSelected);
    NSLog(@"idCategory correspondante: %@", category.idCategory);
     */
    
    // Filtre des stores selon leur idCategory
    NSArray *storesByCategory;
    
    if(pageSelected == 0)
    {
        storesByCategory = allStores;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.idCategory==%@", category.idCategory];
        storesByCategory = [allStores filteredArrayUsingPredicate:predicate];
    }
    
    // Supprime tous les markers sur la map
    [mapView clear];
    
    // Affiche les stores de l'array filtré
    [GoogleMapsManager setUpMarkersWithStores:storesByCategory onMap:mapView];
}

#pragma mark - Google Maps

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    MapInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow" owner:self options:nil] objectAtIndex:0];
    
    Store *store = marker.userData;
    infoWindow.storeName.text = store.name;
    infoWindow.storeCategory.text = store.nameCategory;
    infoWindow.storeRate.text = [NSString stringWithFormat:@"%@ (%@ avis)", store.rate, store.nbOpinions];
    
    if(userLocation!=nil)
        infoWindow.position.text = [LocationManager getDistanceBetween:userLocation.coordinate and:marker.position];
    else
        infoWindow.position.text = @"";
    
    return infoWindow;
}

- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    Store *storeSelected = marker.userData;
    [self performSegueWithIdentifier:@"goToStoreFromMap" sender:storeSelected];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToStoreFromMap"])
    {
        Store *storeSelected = sender;
        MainStoreViewController *destViewController = segue.destinationViewController;
        destViewController.store = storeSelected;
    }
}

@end
