//
//  CoreDataManager.h
//  FindUTC Beta 4
//
//  Created by Sylvain Marchienne on 26/04/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

- (void)displayAllEntities:(NSString*)entity withPredicate:(NSPredicate*)predicate;
- (BOOL)deleteAllEntities:(NSString*)entity withPredicate:(NSPredicate*)predicate;
- (BOOL)deleteEntityWithObjectID:(NSManagedObjectID*)objectID;
- (BOOL)addEntity:(NSString*)entity withProperties:(NSDictionary*)properties;
- (NSArray*)getEntities:(NSString*)entity withPredicate:(NSPredicate*)predicate;
- (BOOL)updateEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate andNewProperties:(NSDictionary*)properties;
- (NSManagedObjectContext*)managedObjectContext;

@end
