@implementation NAUnitTestHelpers

-(NSString *)loadAsset:(NSString *)name
{
  NSBundle *unitTestBundle = [NSBundle bundleForClass:[self class]];
  NSString *pathForFile    = [unitTestBundle pathForResource:name ofType:nil];
  NSString *data           = [NSString stringWithContentsOfFile:pathForFile encoding:NSUTF8StringEncoding error:nil];
  return data;
}

@end