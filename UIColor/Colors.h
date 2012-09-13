@interface UIColor (Extra)
+ (UIColor *) randomColor;
+ (UIColor *) colorWithHex:(uint) hex;
@end

@implementation UIColor (Extra)
+ (UIColor *) randomColor
{
	CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
+ (UIColor *) colorWithHex:(uint) hex
{
	int red, green, blue, alpha;
	
	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);
	alpha = ((hex & 0xFF000000) >> 24);
	
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.f];
}
@end

@interface UIColor (Custom)
+ (UIColor*)customColor;
@end

@implementation UIColor (Custom)
+ (UIColor*)customColor
{
	return [UIColor colorWithHex:0XFFFFFFFF];
}
@end