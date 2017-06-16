//
//  AccountInfoBridge.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "AccountInfoBridge.h"
#import "AccountInfo+CoreDataClass.h"

@implementation AccountInfoBridge

- (instancetype)initWithAccountInfo:(AccountInfo *)info
{
    if (self = [super init]) {
        self.site_account = info.site_account;
        self.site_name = info.site_name;
        self.site_password = info.site_password;
        self.site_icon = info.site_icon;
        self.bound_phone = info.bound_phone;
        self.bound_email = info.bound_email;
    }
    return self;
}

@end
