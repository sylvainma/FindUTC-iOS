//
//  Opinion.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 17/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "Opinion.h"

@implementation Opinion

+ (NSMutableArray*)getAllOpinionsFromIDStore:(NSString*)idStore beforeID:(NSString*)lastIDOpinion
{
    NSString *url = [NSString stringWithFormat:@"/opinions/?store=%@&fields=idOpinion,date,rating,commentary", idStore];
    
    if(lastIDOpinion != nil && ![lastIDOpinion isEqualToString:@""])
        url = [NSString stringWithFormat:@"%@&before=%@", url, lastIDOpinion];
    
    NSArray *JSONOpinions = [API getData:url];
    
    if(JSONOpinions == nil) {
        NSLog(@"Opinion getAllOpinionsFromIDStore: erreur de récupération des opinions");
        return nil;
    }
    
    NSMutableArray *allOpinions = [[NSMutableArray alloc] init];
    
    for(int i=0; i<JSONOpinions.count; i++)
    {
        Opinion *anOpinion = [[Opinion alloc] init];
        anOpinion.idOpinion = [[JSONOpinions objectAtIndex:i] objectForKey:@"idOpinion"];
        anOpinion.date = [[JSONOpinions objectAtIndex:i] objectForKey:@"date"];
        anOpinion.comment = [[JSONOpinions objectAtIndex:i] objectForKey:@"commentary"];

        switch ([[[JSONOpinions objectAtIndex:i] objectForKey:@"rating"] intValue])
        {
            case 1:
                anOpinion.noteName = @"Médiocre";
                break;
            case 2:
                anOpinion.noteName = @"Moyen";
                break;
            case 3:
                anOpinion.noteName = @"Bien";
                break;
            case 4:
                anOpinion.noteName = @"Très bien";
                break;
            case 5:
                anOpinion.noteName = @"Excellent";
                break;
            default:
                anOpinion.noteName = @"";
                break;
        }
        
        [allOpinions addObject:anOpinion];
    }
    
    return allOpinions;
}


+ (BOOL)saveOpinionWithOpinion:(Opinion*)theOpinion getStatus:(NSString**)status andError:(NSString**)error {
    
    //
    //  Paramètrage des données de l'objet à transmettre
    //
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:@{@"idStore" : theOpinion.idStore,
                                                                                @"commentary" : theOpinion.comment,
                                                                                @"rating" : theOpinion.noteNumber,
                                                                                @"login" : theOpinion.login}];
    
    if([theOpinion.idStore isEqualToString:@"0"] && ![theOpinion.storeName isEqualToString:@""])
    {
        [data setObject:theOpinion.storeName forKey:@"storeName"];
    }
    
    //
    //  Envoi de la requête POST
    //
    
    return [API postData:@"/opinions/" withData:data getStatus:status andError:error];
}


@end
