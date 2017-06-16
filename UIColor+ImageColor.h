//
//  UIColor+ImageColor.h
//  PasswordSave
//
//  Created by AnarLong on 2017/6/1.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ImageColor)

+ (UIColor *)mostColorFromImage:(UIImage *)img;

- (CGFloat)redComponent;
- (CGFloat)greenComponent;
- (CGFloat)blueComponent;
- (CGFloat)alphaComponent;

@end
