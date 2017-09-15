//
//  NSDate+Formatter.m
//  PasswordSave
//
//  Created by AnarLong on 15/09/2017.
//  Copyright © 2017 AnarL. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

+ (NSString *)formatDate:(NSDate *)date format:(NSString *)fmt
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:fmt];
    return [df stringFromDate:date];
}

+ (NSString *)formatNow:(NSString *)fmt
{
    return [NSDate formatDate:[NSDate date] format:fmt];
}

+ (NSString *)defaultFormat:(NSDate *)date
{
    return [NSDate formatDate:date format:DEFAULT_DATE_FORMAT];
}

+ (NSString *)defaultFormatNow
{
    return [NSDate formatNow:DEFAULT_DATE_FORMAT];
}


+ (NSDate *)unFormatDate:(NSString *)dateString format:(NSString *)fmt
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:fmt];
    return [df dateFromString:dateString];
}
@end
