//
//  StoreCategory.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 21/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "StoreCategory.h"

@implementation StoreCategory

@synthesize idCategory;
@synthesize nameCategory;
@synthesize nameCategoryPlural;
@synthesize nbStores;

+ (NSMutableArray*)getAllCategories
{
    NSMutableArray *allCategories = [[NSMutableArray alloc] init];
    NSArray *categoriesJSON = [API getData:@"/categories"];
    
    if(categoriesJSON==nil || categoriesJSON.count<1)
    {
        // Récupére toutes les catégories dans CD à défaut d'avoir atteint l'API
        NSLog(@"StoreCategory getAllCategories: Erreur de connexion à l'API, on récupère dans CoreData");
        NSArray *coreData = [[[CoreDataManager alloc] init] getEntities:@"StoreCategory" withPredicate:nil];
        
        if(coreData != nil && coreData.count >= 1)
        {
            for(int i=0; i<coreData.count; i++)
            {
                NSManagedObject *coreDataStore = [coreData objectAtIndex:i];
                
                if (coreDataStore != nil)
                {
                    StoreCategory *aCategory = [[StoreCategory alloc] init];
                    aCategory.idCategory = [coreDataStore valueForKey:@"idCategory"];
                    aCategory.nameCategory = [coreDataStore valueForKey:@"nameCategory"];
                    aCategory.nameCategoryPlural = [coreDataStore valueForKey:@"nameCategoryPlural"];
                    aCategory.nbStores = [coreDataStore valueForKey:@"nbStores"];
                    
                    // Ajout à allCategories
                    [allCategories addObject:aCategory];
                }
            }
        }
        else
        {
            NSLog(@"StoreCategory getAllCategories: Aucun StoreCategory dans CD ou alors erreur d'accès à CD pour les StoreCategory");
            return nil;
        }
    }
    else
    {
        // On a réussit à récupérer les données issues de l'API
        NSLog(@"StoreCategory getAllCategories: Succès de connexion à l'API pour les StoreCategory");
        
        // On a réussi à récupérer les données de l'API, on vide les StoreCategory de CD (c'est ré-enregistré après)
        if(![[[CoreDataManager alloc] init] deleteAllEntities:@"StoreCategory" withPredicate:nil])
            NSLog(@"StoreCategory getAllCategories: Erreur de suppression des anciens StoreCategory");
        
        // On construit l'array allCategories tout en enregistrant chacun dans CD
        for (int i=0; i<categoriesJSON.count; i++)
        {
            NSDictionary *aCategoryData = [categoriesJSON objectAtIndex:i];
            
            if (aCategoryData != nil)
            {
                StoreCategory *aCategory = [[StoreCategory alloc] init];
                aCategory.idCategory = [aCategoryData objectForKey:@"idCategory"];
                aCategory.nameCategory = [aCategoryData objectForKey:@"name"];
                aCategory.nameCategoryPlural = [aCategoryData objectForKey:@"plural"];
                aCategory.nbStores = [aCategoryData objectForKey:@"nbStores"];
                
                // Objet à enregistrer dans CD
                NSDictionary *aCategoryCD = @{@"idCategory" : aCategory.idCategory,
                                              @"nameCategory" : aCategory.nameCategory,
                                              @"nameCategoryPlural" : aCategory.nameCategoryPlural,
                                              @"nbStores" : aCategory.nbStores};
                
                // Enregistrement dans CD
                if(![[[CoreDataManager alloc] init] addEntity:@"StoreCategory" withProperties:aCategoryCD])
                    NSLog(@"Impossible de sauvegarder la catégorie récupérée depuis l'API dans CD");
                
                // Ajout à allCategories
                [allCategories addObject:aCategory];
            }
        }
    }
    
    if(allCategories!=nil && allCategories.count>=1)
        return allCategories;
    else
        return nil;
}

@end
