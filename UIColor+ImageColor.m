//
//  UIColor+ImageColor.m
//  PasswordSave
//
//  Created by AnarLong on 2017/6/1.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "UIColor+ImageColor.h"

@implementation UIColor (ImageColor)

+ (UIColor *)mostColorFromImage:(UIImage *)img
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    CGSize thumbSize = CGSizeMake(img.size.width / 2, img.size.height / 2);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, thumbSize.width, thumbSize.height, 8, thumbSize.width * 4, colorSpace, bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, img.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    unsigned char * data = CGBitmapContextGetData(context);
    if (data == NULL) {
        return nil;
    }
    NSCountedSet * cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    for (int i = 0; i < thumbSize.width; i ++) {
        for (int j = 0; j < thumbSize.height; j ++) {
            int offset = 4 * (i * j);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha = data[offset + 3];
            
            if (alpha > 0) {
                if (red == 255 && green == 255 && blue == 255) {
                } else {
                    NSArray * clr = @[@(red), @(green), @(blue), @(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    NSEnumerator * enumerator = [cls objectEnumerator];
    NSArray * curColor = nil;
    NSArray * maxColor = nil;
    NSUInteger MaxCount = 0;
    while ((curColor = [enumerator nextObject]) != nil) {
        NSUInteger tempCount = [cls countForObject:curColor];
        if (tempCount < MaxCount) {
            continue;
        }
        MaxCount = tempCount;
        maxColor = curColor;
    }
    return [UIColor colorWithRed:([maxColor[0] intValue] / 255.0)  green:([maxColor[1] intValue] / 255.0) blue:([maxColor[2] intValue] / 255.0) alpha:([maxColor[3] intValue] / 255.0)];
}
- (CGFloat)redComponent
{
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    return components[0];
}

- (CGFloat)blueComponent
{
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    return components[1];
}

- (CGFloat)greenComponent
{
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    return components[2];
}

- (CGFloat)alphaComponent
{
    const CGFloat * components = CGColorGetComponents(self.CGColor);
    return components[3];
}


@end
