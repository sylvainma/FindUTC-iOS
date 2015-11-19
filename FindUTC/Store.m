//
//  Store.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 17/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "Store.h"

@implementation Store

static int const UPDATETIME = 7;

+ (id)getStoreByID:(NSString*)theIDStore
{
    BOOL alreadyExistInCD = NO;
    Store *store = [[self alloc] init];
    
    //
    //  On check si les infos du Store sont présents dans CoreData
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idStore == %@", theIDStore];

    NSArray *coreData = [[[CoreDataManager alloc] init] getEntities:@"Store" withPredicate:predicate];
    NSLog(@"CoreData getStoreByID: %@", coreData);
    
    //
    // On vérifie qu'on a bien une réponse non nil: sinon c'est que c'est pas enregistré, on utilise l'API
    //
    if(coreData != nil && coreData.count >= 1)
    {
        // On a une réponse non nulle, donc on a bien un enregistrement correspondant à ce idStore
        alreadyExistInCD = YES;
        NSManagedObject *coreDataStore = [coreData objectAtIndex:0];
        
        // On génére l'objet Store avec les données coredata et on le retourne
        store.idStore = [coreDataStore valueForKey:@"idStore"];
        store.idCategory = [coreDataStore valueForKey:@"idCategory"];
        store.nameCategory = [coreDataStore valueForKey:@"nameCategory"];
        store.name = [coreDataStore valueForKey:@"name"];
        store.adress = [coreDataStore valueForKey:@"adress"];
        store.phone = [coreDataStore valueForKey:@"phone"];
        store.hours = [coreDataStore valueForKey:@"hours"];
        store.desc = [coreDataStore valueForKey:@"desc"];
        store.rate = [coreDataStore valueForKey:@"rate"];
        store.nbOpinions = [coreDataStore valueForKey:@"nbOpinions"];
        store.lat = [coreDataStore valueForKey:@"lat"];
        store.lng = [coreDataStore valueForKey:@"lng"];
        
        // On regarde si le device est connecté au wifi: si oui, on utilise l'API et on met à jour d'office coredata
        //                                               sinon, on utilise le contenu de coredata
        if(![API isWifiOn])
        {
            // On est pas connecté au wifi.
            // On vérifie que la date d'enregistrement n'est pas trop vieille, sinon on utilise le webservice obligatoirement
            double days = floor(fabs([[coreDataStore valueForKey:@"lastUpdate"] timeIntervalSinceNow]/(60*60*24)));
            if(days<UPDATETIME)
            {
                // La date n'est pas trop vieille.
                NSLog(@"ça passe par coreData");
                return store;
            }
        }
    }

        NSArray *storeJSON = [API getData:[NSString stringWithFormat:@"/stores/%@?fields=idStore,idCategory,nameCategory,name,adress,hours,phone,description,rating,nbOpinions,lat,lng", theIDStore]];
        
        if(storeJSON == nil)
        {
            // Si on a des données issues de CoreData, alors on les affiche quand même, c'est toujours mieux que rien
            if(alreadyExistInCD)
            {
                NSLog(@"Store getStoreByID: erreur de récupération des données du store");
                NSLog(@"ça passe finalement par coreData car échec d'accès au webservice");
                return store;
            }
            else
            {
                return nil;
            }
        }
    
        NSLog(@"ça passe par l'API");
    
        NSMutableDictionary *theStore = [NSMutableDictionary dictionaryWithDictionary:[storeJSON objectAtIndex:0]];
    
        switch ([[theStore objectForKey:@"rating"] intValue])
        {
        case 1:
            [theStore removeObjectForKey:@"rating"];
            [theStore setObject:@"Médiocre" forKey:@"rating"];
            break;
        case 2:
            [theStore removeObjectForKey:@"rating"];
            [theStore setObject:@"Moyen" forKey:@"rating"];
            break;
        case 3:
            [theStore removeObjectForKey:@"rating"];
            [theStore setObject:@"Bien" forKey:@"rating"];
            break;
        case 4:
            [theStore removeObjectForKey:@"rating"];
            [theStore setObject:@"Très bien" forKey:@"rating"];
            break;
        case 5:
            [theStore removeObjectForKey:@"rating"];
            [theStore setObject:@"Excellent" forKey:@"rating"];
            break;
        default:
            [theStore removeObjectForKey:@"rating"];
            [theStore setObject:@"" forKey:@"rating"];
            break;
        }
    
        store.idStore = [theStore objectForKey:@"idStore"];
        store.idCategory = [theStore objectForKey:@"idCategory"];
        store.nameCategory = [theStore objectForKey:@"nameCategory"];
        store.name = [theStore objectForKey:@"name"];
        store.adress = [theStore objectForKey:@"adress"];
        store.hours = [theStore objectForKey:@"hours"];
        store.phone = [theStore objectForKey:@"phone"];
        store.desc = [theStore objectForKey:@"description"];
        store.rate = [theStore objectForKey:@"rating"];
        store.nbOpinions = [theStore objectForKey:@"nbOpinions"];
        store.lat = [theStore objectForKey:@"lat"];
        store.lng = [theStore objectForKey:@"lng"];
    
        // Nécessaire car dans CoreData, le champ description n'a pas pu être nommé tel quel, et se nomme thedescription
        // Idem pour rating à la place de rate
        [theStore setObject:[[storeJSON objectAtIndex:0] objectForKey:@"description"] forKey:@"desc"];
        [theStore removeObjectForKey:@"description"];
        [theStore setObject:[[storeJSON objectAtIndex:0] objectForKey:@"rating"] forKey:@"rate"];
        [theStore removeObjectForKey:@"rating"];
    
        // Indique la date de création/mise à jour des données qui vont être stockées dans CoreData
        NSDate *date = [NSDate date];
        [theStore setObject:date forKey:@"lastUpdate"];

        // Enregistrement des données dans CoreData
        if(alreadyExistInCD)
        {
            // Les données existaient déjà dans CoreData sur ce Store, on met à jour
            // Mise à jour (empêche les doublons d'objets avec le même idStore)
            if(![[[CoreDataManager alloc] init] updateEntity:@"Store" withPredicate:predicate andNewProperties:theStore])
                NSLog(@"Erreur lors de la mise à jour dans CoreData des infos reçues par l'API sur le Store");
        }
        else
        {
            // Aucune données sur ce Store n'existaient, on enregistre
            if(![[[CoreDataManager alloc] init] addEntity:@"Store" withProperties:theStore])
                NSLog(@"Erreur lors de la mise en cache (1ère fois) dans CoreData des infos reçues par l'API sur le Store");
        }
    
    return store;
}

+ (id)getAllStoresByCategory:(NSString*)idCategory
{
    NSMutableArray *allStoresByCategory = [[NSMutableArray alloc] init];
    NSArray *storesJSON = [API getData:[NSString stringWithFormat:@"/stores/?category=%@&fields=idStore,idCategory,nameCategory,name,rating,nbOpinions,adress,lat,lng", idCategory]];

    if(storesJSON == nil)
    {
        // Pas d'accès API: on fetch CoreData, si ça donne rien on affichera un msg d'erreur
        NSLog(@"Store getAllStoresByCategory: Impossible de récupérer la liste des Stores");
        
        // Prédicat
        NSPredicate *predicate;
        if([idCategory isEqualToString:@"0"])
            predicate = nil;
        else
            predicate = [NSPredicate predicateWithFormat:@"idCategory == %@", idCategory];
        
        // Fetching de CoreData
        NSArray *coreData = [[[CoreDataManager alloc] init] getEntities:@"Store" withPredicate:predicate];
        NSLog(@"CoreData getAllStoresByCategory: %@", coreData);
        
        if(coreData != nil && coreData.count >= 1)
        {
            for(int i=0; i<coreData.count; i++)
            {
                NSManagedObject *coreDataStore = [coreData objectAtIndex:i];
                
                Store *store = [[Store alloc] init];
                store.idStore = [coreDataStore valueForKey:@"idStore"];
                store.idCategory = [coreDataStore valueForKey:@"idCategory"];
                store.nameCategory = [coreDataStore valueForKey:@"nameCategory"];
                store.name = [coreDataStore valueForKey:@"name"];
                store.rate = [coreDataStore valueForKey:@"rate"];
                store.nbOpinions = [coreDataStore valueForKey:@"nbOpinions"];
                store.adress = [coreDataStore valueForKey:@"adress"];
                store.lat = [coreDataStore valueForKey:@"lat"];
                store.lng = [coreDataStore valueForKey:@"lng"];
                
                [allStoresByCategory addObject:store];
            }
        }
    }
    else
    {
        // On a réussit à accéder à l'API
        // On remplit l'array avec chaque store
        for(int i=0; i<storesJSON.count; i++)
        {
            NSMutableDictionary *aStore = [NSMutableDictionary dictionaryWithDictionary:[storesJSON objectAtIndex:i]];
            
            Store *store = [[Store alloc] init];
            store.idStore = [aStore objectForKey:@"idStore"];
            store.idCategory = [aStore objectForKey:@"idCategory"];
            store.nameCategory = [aStore objectForKey:@"nameCategory"];
            store.name = [aStore objectForKey:@"name"];
            store.nbOpinions = [aStore objectForKey:@"nbOpinions"];
            store.adress = [aStore objectForKey:@"adress"];
            store.lat = [aStore objectForKey:@"lat"];
            store.lng = [aStore objectForKey:@"lng"];
            
            switch ([[aStore objectForKey:@"rating"] intValue])
            {
                case 1:
                    store.rate = @"Médiocre";
                    break;
                case 2:
                    store.rate = @"Moyen";
                    break;
                case 3:
                    store.rate = @"Bien";
                    break;
                case 4:
                    store.rate = @"Très bien";
                    break;
                case 5:
                    store.rate = @"Excellent";
                    break;
                default:
                    store.rate = @"";
                    break;
            }
            
            [allStoresByCategory addObject:store];
        }

    }
    
    if(allStoresByCategory!=nil && allStoresByCategory.count>=1)
        return allStoresByCategory;
    else
        return nil;
}

@end
