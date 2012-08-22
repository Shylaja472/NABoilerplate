//
//  NAPersistentStore.h
//  Recipes
//
//  Created by Audun Kjelstrup on 20.08.12.
//  Copyright (c) 2012 Audun Kjelstrup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAPersistentStore : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(NAPersistentStore *) sharedStore;
-(void) deleteEntitiesWithDescription: (NSString *) entityDescription;
-(void) deleteStore;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
