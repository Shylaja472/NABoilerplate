//
//  NAPersistentStore.m
//  Recipes
//
//  Created by Audun Kjelstrup on 20.08.12.
//  Copyright (c) 2012 Audun Kjelstrup. All rights reserved.
//

#import "NAPersistentStore.h"

//  !! Remember to change these !!

NSString * const kDefaultStoreFileName = @"CoreDataStore.sqlite";
NSString * const kDefaultModelName = @"CoreDataModel";

@implementation NAPersistentStore

+ (NAPersistentStore *) sharedStore{
  
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)deleteStore
{
  
  NSPersistentStoreCoordinator *storeCoordinator = [self persistentStoreCoordinator];
  
  NSArray *stores = [storeCoordinator persistentStores];
  
  for(NSPersistentStore *store in stores) {
    [storeCoordinator removePersistentStore:store error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
  }
  _persistentStoreCoordinator=nil;
  _managedObjectContext=nil;
  
}

- (void)deleteEntitiesWithDescription: (NSString *) entityDescription
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  NSError *error;
  NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  
  
  for (NSManagedObject *managedObject in items) {
    [self.managedObjectContext deleteObject:managedObject];
    NSLog(@"%@ object deleted",entityDescription);
  }
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
  }
}



- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
    {
      NSLog(@"Could not save. Unresolved error %@, %@", error, [error userInfo]);
    }
  }
}


#pragma mark - Core Data stack

- (NSManagedObjectContext*)managedObjectContext
{
  if (_managedObjectContext) return _managedObjectContext;
  
  NSPersistentStoreCoordinator *coord = [self persistentStoreCoordinator];
  if (!coord) return nil;
  
  _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_managedObjectContext setPersistentStoreCoordinator:coord];
  
  return _managedObjectContext;
}

- (NSManagedObjectModel*)managedObjectModel
{
  if (_managedObjectModel) return _managedObjectModel;
  
  NSString *path = [[NSBundle mainBundle] pathForResource:kDefaultModelName
                                                   ofType:@"momd"];
  if (!path) {
    path = [[NSBundle mainBundle] pathForResource:kDefaultModelName
                                           ofType:@"mom"];
  }
  NSAssert(path != nil, @"Unable to find DataModel in main bundle");
  NSURL *url = [NSURL fileURLWithPath:path];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator;
{
  if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  if (![fileManager fileExistsAtPath:DocumentsDirectory]) {
    
    [fileManager createDirectoryAtPath:DocumentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
  }
  
  NSString *filePath = nil;
  filePath = [DocumentsDirectory stringByAppendingPathComponent:kDefaultStoreFileName];
  
  
  NSURL *url = [NSURL fileURLWithPath:filePath];
  NSManagedObjectModel *mom = [self managedObjectModel];
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                 initWithManagedObjectModel:mom];
  
  NSError *error = nil;
  if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                configuration:nil
                                                          URL:url
                                                      options:nil
                                                        error:&error]) {
    return _persistentStoreCoordinator;
  }
  
  
  if ([[NSFileManager defaultManager] removeItemAtURL:url error:&error]){
    if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:url
                                                        options:nil
                                                          error:&error]) {
      return _persistentStoreCoordinator;
    }
  }else{
    NSLog(@"Could not create persistent store");
  }
  
  _persistentStoreCoordinator = nil;
  NSDictionary *ui = [error userInfo];
  if (![ui valueForKey:NSDetailedErrorsKey]) {
    NSLog(@"%@:%@ Error adding store %@", [self class], NSStringFromSelector(_cmd), [error localizedDescription]);
  } else {
    for (NSError *suberror in [ui valueForKey:NSDetailedErrorsKey]) {
      NSLog(@"%@:%@ Error: %@", [self class], NSStringFromSelector(_cmd), [suberror localizedDescription]);
    }
  }
  NSAssert(NO, @"Failed to initialize the persistent store");
  return nil;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
