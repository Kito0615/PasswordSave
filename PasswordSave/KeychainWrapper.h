//
//  KeychainWrapper.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/17.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define SERVICE_ACCOUNT_KEY @"com.anarl.app.password"
#define SERVICE_PASSWORD_KEY @"com.anarl.app.account"

@interface KeychainWrapper : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
