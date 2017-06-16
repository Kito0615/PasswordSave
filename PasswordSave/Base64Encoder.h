//
//  Base64Encoder.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Encoder : NSObject

+ (NSString *)base64EncodeString:(NSString *)string;
+ (NSData *)base64EncodeStringToData:(NSString *)string;

+ (NSString *)base64DecodeString:(NSString *)string;
+ (NSString *)base64DecodeStringFromData:(NSData *)data;

@end
