//
//  Opinion.h
//  FindUTC
//
//  Created by Sylvain Marchienne on 17/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "API.h"

@interface Opinion : NSObject

@property (strong, readwrite) NSString *idOpinion;
@property (strong, readwrite) NSString *date;
@property (strong, readwrite) NSString *comment;
@property (strong, readwrite) NSString *noteName;

// Pour l'enregistrement d'un avis uniquement
@property (strong, readwrite) NSString *idStore;
@property (strong, readwrite) NSString *storeName;
@property (strong, readwrite) NSString *noteNumber;
@property (strong, readwrite) NSString *login;

+ (NSMutableArray*)getAllOpinionsFromIDStore:(NSString*)idStore beforeID:(NSString*)lastIDOpinion;
+ (BOOL)saveOpinionWithOpinion:(Opinion*)theOpinion getStatus:(NSString**)status andError:(NSString**)error;

@end
