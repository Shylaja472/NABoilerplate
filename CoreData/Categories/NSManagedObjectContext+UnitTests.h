//
//  NSManagedObjectContext+UnitTests.h
//  Tidsskriftet
//
//  Created by Audun Kjelstrup on 31.05.12.
//  Copyright (c) 2012 Nordaaker Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (UnitTests)
+ (NSManagedObjectContext *)inMemoryMOCFromBundle:(NSBundle *)appBundle withConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;
@end
