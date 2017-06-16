//
//  AccountInfoBridge.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountInfo;
@interface AccountInfoBridge : NSObject

@property (nullable, nonatomic, retain) NSData *site_account;
@property (nullable, nonatomic, copy) NSString *site_icon;
@property (nullable, nonatomic, copy) NSString *site_name;
@property (nullable, nonatomic, retain) NSData *site_password;
@property (nullable, nonatomic, copy) NSString *bound_phone;
@property (nullable, nonatomic, copy) NSString *bound_email;

- (instancetype)initWithAccountInfo:(AccountInfo *)info;

@end
