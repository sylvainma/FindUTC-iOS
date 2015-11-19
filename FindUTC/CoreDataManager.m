//
//  CoreDataManager.m
//  FindUTC Beta 4
//
//  Created by Sylvain Marchienne on 26/04/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

// Si NO, affiche les valeurs des NSManagedObject en console (!uniquement pour le debugging!)
static BOOL const DATAFAULT = YES;

- (void)displayAllEntities:(NSString*)entity withPredicate:(NSPredicate*)predicate
{
    NSLog(@"%@", [self getEntities:entity withPredicate:predicate]);
}

- (BOOL)deleteAllEntities:(NSString*)entity withPredicate:(NSPredicate*)predicate
{
    // Génération du managedObjectContext
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Préparation de la requête
    NSFetchRequest *delRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *delEntity = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [delRequest setEntity:delEntity];
    
    // Ajout du prédicat (s'il n'est pas nul)
    if(predicate != nil)
    {
        [delRequest setPredicate:predicate];
    }
    
    // Exécution de la requête
    NSError *delError = nil;
    NSArray *delArray = [context executeFetchRequest:delRequest error:&delError];
    
    if(delError == nil)
    {
        // Destruction successive de chaque réponse
        for(NSManagedObject *store in delArray)
        {
            [context deleteObject:store];
        }
        
        // Enregistrement des destructions
        NSError *saveError = nil;
        if (![context save:&saveError])
        {
            NSLog(@"deleteAllEntities:withPredicate error: %@", saveError);
            return NO;
        }
        
        return YES;
    }
    
    NSLog(@"deleteAllEntities:withPredicate error: %@", delError);
    return NO;
}

- (BOOL)deleteEntityWithObjectID:(NSManagedObjectID*)objectID
{
    // Génération du managedObjectContext
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Suppression
    [context deleteObject:[context objectRegisteredForID:objectID]];
    
    // Enregistrement des destructions
    NSError *saveError = nil;
    if (![context save:&saveError])
    {
        NSLog(@"deleteEntityWithObjectID error: %@", saveError);
        return NO;
    }
    
    return YES;
}

- (BOOL)addEntity:(NSString*)entity withProperties:(NSDictionary*)properties
{
    // Génération du managedObjectContext
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Préparation de l'objet à enregistrer
    NSManagedObject *newEntity = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
    
    for (NSString* key in properties)
    {
        [newEntity setValue:[properties objectForKey:key] forKey:key];
    }
    
    // Enregistrement
    NSError *error = nil;
    if([context save:&error])
    {
        return YES;
    }
    
    NSLog(@"addEntity:withProperties error: %@", error);
    return NO;
}

- (NSArray*)getEntities:(NSString*)entity withPredicate:(NSPredicate*)predicate
{
    // Génération du managedObjectContext
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Préparation de la requête
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    // Debugging
    DATAFAULT ? nil : [request setReturnsObjectsAsFaults:NO];
    
    // Ajout du prédicat (s'il n'est pas nul)
    if(predicate != nil)
    {
        [request setPredicate:predicate];
    }
    
    // Exécution de la requête
    NSError *error = nil;
    NSArray *answers = [context executeFetchRequest:request error:&error];
    
    if(error == nil) {
        return answers;
    }
    else {
        NSLog(@"getEntities:withPredicate error: %@", error);
        return nil;
    }
    
}

- (BOOL)updateEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate andNewProperties:(NSDictionary*)newProperties
{
    // Récupération des objets à modifier
    NSArray *answer = [self getEntities:entity withPredicate:predicate];
    
    if(answer == nil || answer.count==0)
    {
        NSLog(@"updateEntity:withPredicate:andNewProperties error: Aucun objet retourné avec le prédicat donné");
        return NO;
    }
    else if(answer.count>1)
    {
        NSLog(@"updateEntity:withPredicate:andNewProperties error: Plusieurs réponses ont été retournées avec le prédicat donné, impossible de modifier plusieurs objets à la fois ");
        return NO;
    }
    
    // Préparation du nouvel objet, avec l'objet d'origine et les modifications souhaitées de newProperties
    NSMutableDictionary *finalProperties = [[NSMutableDictionary alloc] init];
    for(NSString* key in [[answer[0] entity] attributesByName])
    {
        if([newProperties valueForKey:key] != nil)
            [finalProperties setObject:[newProperties valueForKey:key] forKey:key];
        else if([answer[0] valueForKey:key] != nil)
            [finalProperties setObject:[answer[0] valueForKey:key] forKey:key];
    }
    
    // Enregistrement du nouvel objet
    if(![self addEntity:entity withProperties:finalProperties])
    {
        NSLog(@"updateEntity:withPredicate:andNewProperties error: Erreur lors de la création du nouvel objet");
        return NO;
    }
    
    // Récupération de l'IDObject de l'objet initial (pour le supprimer et éviter le doublon)
    NSManagedObjectID *oldIDObject = [answer[0] objectID];
    
    // Suppression de l'ancien objet
    if (![self deleteEntityWithObjectID:oldIDObject])
    {
        NSLog(@"updateEntity:withPredicate:andNewProperties error: Erreur lors de la suppression de l'ancien objet !Risque de doublons!");
        return NO;
    }
    
    return YES;
}

- (NSManagedObjectContext*)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
