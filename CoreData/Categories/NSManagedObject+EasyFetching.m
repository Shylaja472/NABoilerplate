//
//  NSManagedObject+EasyFetching.m
//
//  NSManagedObject(EasyFetching)  http://www.cimgf.com/2011/03/13/super-happy-easy-fetching-in-core-data/
//  NSManagedObjectContext(SimpleFetch) http://cocoawithlove.com/2008/03/core-data-one-line-fetch.html
//

#import "NSManagedObject+EasyFetching.h"
#import "NAPersistentStore.h"

//NSManagedObject+EasyFetching.m
@implementation NSManagedObject (EasyFetching)

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
{
  return [self respondsToSelector:@selector(entityInManagedObjectContext:)] ?
  [self performSelector:@selector(entityInManagedObjectContext:) withObject:context] :
  [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}

+ (NSArray *)fetchAllObjects;
{
  NSManagedObjectContext *context = [[NAPersistentStore sharedStore] managedObjectContext];
  return [self fetchAllObjectsInContext:context];
}

+ (NSArray *)fetchAllObjectsInContext:(NSManagedObjectContext *)context;
{
  NSEntityDescription *entity = [self entityDescriptionInContext:context];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  NSError *error = nil;
  NSArray *results = [context executeFetchRequest:request error:&error];
  if (error != nil)
  {
    NSLog(@"%@", error);
  }
  return results;
}

@end

@implementation NSManagedObjectContext (SimpleFetch)
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ...
{
  NSEntityDescription *entity = [NSEntityDescription
                                 entityForName:newEntityName inManagedObjectContext:self];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  
  if (stringOrPredicate)
  {
    NSPredicate *predicate;
    if ([stringOrPredicate isKindOfClass:[NSString class]])
    {
      va_list variadicArguments;
      va_start(variadicArguments, stringOrPredicate);
      predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                         arguments:variadicArguments];
      va_end(variadicArguments);
    }
    else
    {
      NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
                @"Second parameter passed to %s is of unexpected class %@",
                sel_getName(_cmd), [stringOrPredicate class]);
      predicate = (NSPredicate *)stringOrPredicate;
    }
    
    [request setPredicate:predicate];
  }
  
  NSError *error = nil;
  NSArray *results = [self executeFetchRequest:request error:&error];
  
  if (error != nil)
  {
    NSLog(@"Oops: %@",[error description]);
  }
  
  return [NSSet setWithArray:results];
}
@end


