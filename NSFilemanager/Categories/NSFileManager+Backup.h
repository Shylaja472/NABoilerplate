//
//  NSFileManager+Backup.h
//  Tidsskriftet
//
//  Created by Audun Holm Ellertsen on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Backup)

- (void)addSkipBackupAttributeToDirectory:(NSString *) path;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
