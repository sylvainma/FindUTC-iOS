//
//  API.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 17/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "API.h"
#import "keys.h"

@implementation API

// URL de l'API de base (utile pour la première connexion)
static NSString *const API_URL = @"http://assos.utc.fr/findutc/api/v1";
static NSString *const API_KEY = FINDUTC_API_KEY;
//static NSString *const API_URL = @"http://findutc.sylvainmarchienne.fr/api";
//static NSString *const API_URL = @"http://localhost:8888/Findutc/api/v2";

+ (void)checkApi
{
    // URL de l'API (dernière en date)
    NSString *URL = [API getAPIUrl];
    
    // Requête
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // On check si la connexion a réussi
    if([response statusCode] != 200)
    {
        NSLog(@"Erreur de connexion à l'API, code erreur: %ld", (long)[response statusCode]);
    }
    else
    {
        // La connexion à réussi, on parse le JSON
        NSError *errorJSON = nil;
        id object = [NSJSONSerialization JSONObjectWithData:respData options:0 error:&errorJSON];
        
        if(errorJSON != nil)
        {
            NSLog(@"Connexion à l'API, échec pour parser le fichier JSON");
        }
        else
        {
            // On récupère le JSON metadata
            NSDictionary *metadata = [object objectForKey:@"metadata"];
            NSLog(@"%@", metadata);
            
            if([metadata objectForKey:@"ApiURL"])
            {
                // On a bien reçue l'url de l'API, on compare pour éventuellement mettre à jour son URL
                NSString *ApiURL = [metadata objectForKey:@"ApiURL"];
                
                if(![ApiURL isEqualToString:URL])
                {
                    // L'URL a changé, on met à jour dans CoreData
                    NSLog(@"différente");
                    
                    // Si une entité existe déjà dans CD, on met à jour
                    NSArray *coreData = [[[CoreDataManager alloc] init] getEntities:@"Api" withPredicate:nil];
                    
                    if(coreData != nil && coreData.count == 1)
                    {
                        if([[[CoreDataManager alloc]init] updateEntity:@"Api"
                                                         withPredicate:nil
                                                      andNewProperties:@{@"url" : ApiURL}])
                        {
                            // Modification réussie
                            NSLog(@"Modification réussie de l'URL de l'API dans CD");
                        }
                        else
                        {
                            // Echec modification
                            NSLog(@"Echec de la modification de l'URL de l'API dans CD");
                        }
                            
                    }
                    // Sinon, on en créé une
                    else
                    {
                        if([[[CoreDataManager alloc] init] addEntity:@"Api" withProperties:@{@"url" : ApiURL}])
                        {
                            // Création réussie
                            NSLog(@"Création réussie de l'URL de l'API dans CD");
                        }
                        else
                        {
                            // Echec modification
                            NSLog(@"Echec de la Création de l'URL de l'API dans CD");
                        }
                    }
                    
                }
                
            }
                
        }
    }
    
}

+ (NSString*)getAPIUrl
{
    NSString *APIUrl = nil;
    
    //
    //  Trop long
    //
    /*
    // On recherche dans CoreData la valeur actuelle de l'ApiURL
    NSArray *coreData = [[[CoreDataManager alloc] init] getEntities:@"Api" withPredicate:nil];
    
    if(coreData != nil && coreData.count == 1)
    {
        NSManagedObject *coreDataApi = [coreData objectAtIndex:0];
        if(coreDataApi != nil)
        {
            APIUrl = [coreDataApi valueForKey:@"url"];
        }
    }
    */
    // Si la valeur ApiURL est nulle dans CD, on fournit la constante d'origine
    if(APIUrl == nil || [APIUrl isEqualToString:@""])
        return API_URL;
    else
        return APIUrl;
}

+ (NSArray*)getData:(NSString*)theURL
{
    NSString *URL = [NSString stringWithFormat:@"%@%@", [API getAPIUrl], theURL];
    
    //
    //  Connexion à l'API
    //
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
    
    // Authentification sur l'API
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization-api-key"];
    
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //
    //  Vérifie que la réponse est correcte (header: code 200)
    //
    
    if([response statusCode] != 200) {
        NSLog(@"L'API a renvoyé un code erreur: %ld", (long)[response statusCode]);
        return nil;
    }
    
    //
    //  Parse du JSON en réponse
    //
    
    NSError *errorJSON = nil;
    id object = [NSJSONSerialization JSONObjectWithData:respData options:0 error:&errorJSON];
    
    if(errorJSON != nil) {
        NSLog(@"Échec pour parser le fichier JSON");
        return nil;
    }
    
    //
    //  Vérifie la bonne forme du résultat (objet JSON avec success & data)
    //
    
    if([object objectForKey:@"data"]==nil || !([[object objectForKey:@"data"] isKindOfClass:[NSArray class]])) {
        NSLog(@"Erreur des données: la réponse n'est pas sous la forme attendue");
        return nil;
    }
    
    //
    //  Retourne le tableau data si pas d'erreur
    //
    
    NSArray *data = [object objectForKey:@"data"];
    return data;
}

+ (BOOL)postData:(NSString*)theURL withData:(NSDictionary*)data getStatus:(NSString**)status andError:(NSString**)error
{
    if(data == nil || [data count]==0)
        return NO;
    
    //
    //  Formatage des paramètres
    //
    NSString *params = @"";
    
    for(NSString* key in data)
    {
        params = [params stringByAppendingString:[NSString stringWithFormat:@"&%@=", key]]; // nom arg
        params = [params stringByAppendingString:[API URLEncodeStringFromString:[data objectForKey:key]]];                  // contenu arg
    }
    
    // Encodage UTF8 standart pour le tranfert de données via requête POST
    // (norme: application/x-www-form-urlencoded)
    //params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"Paramètres: %@", params);
    
    //
    //  Construction de la requête
    //
    
    params = [API URLEncode:params];
    //NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *postData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%ld",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [API getAPIUrl], theURL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization-api-key"];
    [request setHTTPBody:postData];
    
    //
    //  Préparation de la variable de récupération de la réponse, et de la variable d'erreur
    //
    
    NSData *returnData = [[NSData alloc] init];
    NSHTTPURLResponse *response = nil;
    NSError *error1 = nil;    // Pour la connexion
    
    //
    //  Envoi de la requête
    //
    
    returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
    
    //
    //  Vérification de la connexion
    //
    
    if(error1 != nil)
    {
        NSLog(@"Erreur de connexion à l'API pour la requête POST");
        return NO;
    }
    
    //
    //  Récupération du status et de l'erreur (si erreur il y a)
    //
    
    *status = [NSString stringWithFormat:@"%ld", (long)[response statusCode]];
    *error = [NSString stringWithFormat:@""];
    
    if (![*status isEqualToString:@"200"])
    {
        // Echec de l'enregistrement
        NSLog(@"Erreur d'enregistrement des données POST");
        
        // On récupère le message d'erreur
        NSError *errorJSON = nil;
        id object = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&errorJSON];
        
        if(errorJSON != nil || [object objectForKey:@"error"]==nil)
        {
            NSLog(@"Échec pour parser le fichier JSON de la réponse erreur OU la réponse n'est pas sous la forme attendue");
            return NO;
        }
        *error = [object objectForKey:@"error"];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)postData:(NSString*)theURL withData:(NSDictionary*)data
{
    return [API postData:theURL withData:data getStatus:nil andError:nil];
}

+ (NSString*)URLEncode:(NSString*)url
{
    NSString *newURL = [NSString stringWithFormat:@"%s", [url UTF8String]];
    newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return newURL;
}

+ (NSString *)URLEncodeStringFromString:(NSString *)string
{
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    string = [string stringByReplacingOccurrencesOfString:@"&"
                                         withString:@"%26"];
    string = [string stringByReplacingOccurrencesOfString:@"/"
                                            withString:@"%2F"];
    return string;
}

+ (BOOL)isWifiOn
{
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    return (netStatus==ReachableViaWiFi);
}

@end



