//
//  NSManagedObjectContext+UnitTests.m
//  Tidsskriftet
//
//  Created by Audun Kjelstrup on 31.05.12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import "NSManagedObjectContext+UnitTests.h"

@implementation NSManagedObjectContext (UnitTests)

+ (NSManagedObjectContext *)inMemoryMOCFromBundle:(NSBundle *)appBundle withConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType{
	// get model from app bundle passed into method
	NSArray *bundleArray = [NSArray arrayWithObject:appBundle];
	NSAssert([bundleArray count] == (unsigned)1, @"1 object in bundle array");
	NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:bundleArray];
  
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	if (coordinator == nil) {
		NSLog(@"Can't get instance of NSPersistentStoreCoordinator");
		return nil;
	}
  
	// Add an in-memory persistent store to the coordinator.
  
	NSError *addStoreError = nil;
	if (![coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&addStoreError]) {
		NSLog(@"Error setting up in-memory store unit test: %@", addStoreError);
		return nil;
	}
  
	// Now we can set up the managed object context and assign it to persistent store coordinator.
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
	[context setPersistentStoreCoordinator: coordinator];
	NSAssert( context != nil, @"Can't set up managed object context for unit test.");
  
	return context;
}

@end
