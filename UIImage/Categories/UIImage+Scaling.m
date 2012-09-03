#import	UIImage+Scaling.h

@implementation UIImage (Scaling)

-(UIImage*) scaledToDevice
{
 return [UIImage imageWithCGImage:[self CGImage] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
}

@end