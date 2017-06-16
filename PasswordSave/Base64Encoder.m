//
//  Base64Encoder.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "Base64Encoder.h"

@implementation Base64Encoder

+ (NSString *)base64EncodeString:(NSString *)string
{
    if (string == nil) {
        return @"";
    }
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+ (NSData *)base64EncodeStringToData:(NSString *)string
{
    if (string == nil) {
        return nil;
    }
    return [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:0];
}

+ (NSString *)base64DecodeString:(NSString *)string
{
    if (string == nil) {
        return @"";
    }
    NSData * data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)base64DecodeStringFromData:(NSData *)data
{
    if (data == nil) {
        return @"";
    }
    NSData * decodeData = [[NSData alloc] initWithBase64EncodedData:data options:0];
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

@end
