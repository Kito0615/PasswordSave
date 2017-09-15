//
//  NSDate+Formatter.h
//  PasswordSave
//
//  Created by AnarLong on 15/09/2017.
//  Copyright © 2017 AnarL. All rights reserved.
//

#import <Foundation/Foundation.h>

// Default format : yyyy/MM/dd HH:mm:ss.S
#define DEFAULT_DATE_FORMAT @"yyyy/MM/dd HH:mm:ss.S"
@interface NSDate (Formatter)

+ (NSString *)formatDate:(NSDate *)date format:(NSString *)fmt;
+ (NSString *)formatNow:(NSString *)fmt;
+ (NSString *)defaultFormat:(NSDate *)date;
+ (NSString *)defaultFormatNow;

+ (NSDate *)unFormatDate:(NSString *)dateString format:(NSString *)fmt;

@end
