//
//  NSFileManager+Backup.m
//  Tidsskriftet
//
//  Created by Audun Holm Ellertsen on 11/10/12.
//
//

#import <sys/xattr.h>
#import "NSFileManager+Backup.h"

@implementation NSFileManager (Backup)

-(NSMutableArray *)scanURL:(NSURL *)directoryToScan
{
  // Create a local file manager instance
 // NSFileManager *localFileManager=[[NSFileManager alloc] init];

  // Enumerate the directory (specified elsewhere in your code)
  // Request the two properties the method uses, name and isDirectory
  // Ignore hidden files
  // The errorHandler: parameter is set to nil. Typically you'd want to present a panel
  NSDirectoryEnumerator *dirEnumerator = [self enumeratorAtURL:directoryToScan
                                                includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey,
                                                                                                     NSURLIsDirectoryKey,nil]
                                                                   options:0
                                                              errorHandler:nil];

  // An array to store the all the enumerated file names in
  NSMutableArray *theArray=[NSMutableArray array];

  // Enumerate the dirEnumerator results, each value is stored in allURLs
  for (NSURL *theURL in dirEnumerator) {

    // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
    NSString *fileName;
    [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];

    // Retrieve whether a directory. From NSURLIsDirectoryKey, also
    // cached during the enumeration.
    NSNumber *isDirectory;
    [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];

//    // Ignore files under the _extras directory
//    if (([fileName caseInsensitiveCompare:@"_extras"]==NSOrderedSame) &&
//            ([isDirectory boolValue]==YES))
//    {
//      [dirEnumerator skipDescendants];
//    }
//    else
    {
      // Add full path for non directories
      if ([isDirectory boolValue]==NO)
        [theArray addObject:theURL];

    }
  }

  // Do something with the path URLs.
 // NSLog(@"theArray - %@",theArray);
  return theArray;
}

- (void)addSkipBackupAttributeToDirectory:(NSString *) path;
{
  NSArray *files = [self scanURL:[NSURL fileURLWithPath:path]];
  for (NSURL *file in files)
  {
    [NSFileManager addSkipBackupAttributeToItemAtURL:file];
  }
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
  const char* filePath = [[URL path] fileSystemRepresentation];
  const char* attrName = "com.apple.MobileBackup";
  if (&NSURLIsExcludedFromBackupKey == nil) {
    // iOS 5.0.1 and lower
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
  } else {
    // First try and remove the extended attribute if it is present
    int result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
    if (result != -1) {
      // The attribute exists, we need to remove it
      int removeResult = removexattr(filePath, attrName, 0);
      if (removeResult == 0) {
        NSLog(@"Removed extended attribute on file %@", URL);
      }
    }
    
    // Set the new key
    return [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
  }
}

@end
