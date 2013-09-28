//Category demonstrating the use of expressions to create efficient fetches from store for cases where you need information and don't  want to run through all objects in memory to find it

#import "NSManagedObject+MostRecentObject.h"

@implementation NSManagedObject (MostRecentObject)

+ (NSNumber*)mostRecentIdentifierFromContext:(NSManagedObjectContext*)moc_  {
	NSError *error = nil;
	NSArray *result = [self fetchMostRecentIdentifierFromContext:moc_ error:&error];
	if (error) {
#ifdef NSAppKitVersionNumber10_0
		[NSApp presentError:error];
#else
		NSLog(@"error: %@", error);
#endif
	}
  
	return [[result lastObject] valueForKey:@"identifier"];
}
+ (NSArray*)fetchMostRecentIdentifierFromContext:(NSManagedObjectContext*)moc_ inCategory:(NewsCategory*)withCategory_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;
  
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext:moc_];
  [request setEntity:entity];
  [request setResultType:NSDictionaryResultType];
  
    // Create an expression for the key path.
  NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForKeyPath:@"identifier"]]];
  
  NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
  [expressionDescription setName:@"identifier"];
  [expressionDescription setExpression:maxExpression];
  [expressionDescription setExpressionResultType:NSInteger16AttributeType];
  [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
  
  
	NSArray *result = [moc_ executeFetchRequest:request error:&error];
	if (error_) *error_ = error;
    return result;
}

@end