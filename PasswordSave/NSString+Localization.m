//
//  NSString+Localization.m
//  PasswordSave
//
//  Created by AnarLong on 2017/6/2.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "NSString+Localization.h"

@implementation NSString (Localization)

+ (NSString *)preferedLanguageCode
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSArray * languages = [def objectForKey:@"AppleLanguages"];
    NSString * preferedLanguage = [languages firstObject];
    return preferedLanguage;
}

@end
