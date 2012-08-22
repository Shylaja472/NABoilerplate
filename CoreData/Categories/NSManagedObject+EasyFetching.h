//
//  NSManagedObject+EasyFetching.h
//  Tidsskriftet
//
//  Created by Audun Kjelstrup on 24.05.12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (EasyFetching)

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetchAllObjects;
+ (NSArray *)fetchAllObjectsInContext:(NSManagedObjectContext *)context;

@end

@interface NSManagedObjectContext (SimpleFetch)
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ...;
@end