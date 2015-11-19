//
//  GoogleMapsManager.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 22/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "GoogleMapsManager.h"

@implementation GoogleMapsManager

+ (GMSMapView*)initMapWithLocation:(NSDictionary*)location andZoom:(double)zoom
{
    // Vérification des coordonnées
    CLLocationCoordinate2D coord = [GoogleMapsManager getCoordinateFromLocation:location];
    
    // Création de la map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coord.latitude
                                                            longitude:coord.longitude
                                                                 zoom:zoom];
    GMSMapView *map = [GMSMapView mapWithFrame:[[UIScreen mainScreen] bounds] camera:camera];
    
    // Ajout des bouttons
    map.settings.compassButton = YES;
    map.settings.myLocationButton = YES;
    
    return map;
}

+ (GMSMapView*)initMapOnMarkerWithStore:(Store*)store andLocation:(NSDictionary*)location
{
    // Génération de la map
    GMSMapView *map = [GoogleMapsManager initMapWithLocation:location andZoom:16.5];
    
    NSLog(@"%@", map);
    
    // Création du marker sur cette map
    [GoogleMapsManager setUpMarkerWithStore:store andLocation:location onMap:map];
    
    return map;
}

+ (void)setUpMarkerWithStore:(Store*)store andLocation:(NSDictionary*)location onMap:(GMSMapView*)map
{
    // Vérification des coordonnées
    CLLocationCoordinate2D coord = [GoogleMapsManager getCoordinateFromLocation:location];
    
    // Création d'un marker
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    // Configuration visuelle
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:46/255.0 green:142/255.0 blue:79/255.0 alpha:1.0]];
    
    // Données
    marker.userData = store;
    marker.title = store.name;
    marker.snippet = store.desc;
    
    // Position du marker
    marker.position = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
    
    // Insertion sur la map
    marker.map = map;
}

+ (void)setUpMarkersWithStores:(NSArray*)allStores onMap:(GMSMapView*)map
{
    // On vérifie qu'allStores n'est pas nul
    if(allStores == nil || allStores.count == 0)
        return;
    
    // Affichage successif
    for(Store *aStore in allStores)
    {
        // Avec les coordonnées GPS de l'objet store
        // Création de l'objet coordonnées
        NSDictionary *coord = @{@"latitude" : aStore.lat,
                                @"longitude" : aStore.lng};
        
        // Positionnement du marker
        [GoogleMapsManager setUpMarkerWithStore:aStore andLocation:coord onMap:map];
        
        // Avec requête pour trouver les coordonnées GPS
        /*
        // Recherche de ses coordonnées GPS à partir de son adresse postale, puis affichage
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:aStore.adress
                     completionHandler:^(NSArray* placemarks, NSError* error)
         {
             // objectAtIndex:0 est le résultat le plus probant
             CLPlacemark *thePlacemark = [placemarks objectAtIndex:0];
             
             // Création de l'objet coordonnées
             NSDictionary *coord = @{@"latitude" : [NSString stringWithFormat:@"%f",
                                                    [thePlacemark location].coordinate.latitude],
                                     @"longitude" : [NSString stringWithFormat:@"%f",
                                                     [thePlacemark location].coordinate.longitude]};
             
             // Positionnement du marker
             [GoogleMapsManager setUpMarkerWithStore:aStore andLocation:coord onMap:map];
         }];
        */
    }
    
}

+ (CLLocationCoordinate2D)getCoordinateFromLocation:(NSDictionary*)location
{
    CLLocationCoordinate2D coord;
    
    // Si les coordonnées ne sont pas bonnes, on met la position par défaut au centre de Compiègne
    if(location==nil || !location[@"latitude"] || !location[@"longitude"])
    {
        coord.latitude = 49.417806;
        coord.longitude = 2.825926;
    }
    else
    {
        coord.latitude = [location[@"latitude"] doubleValue];
        coord.longitude = [location[@"longitude"] doubleValue];
    }
    
    return coord;
}

@end
