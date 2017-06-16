//
//  AccountInfo+CoreDataProperties.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "AccountInfo+CoreDataProperties.h"

@implementation AccountInfo (CoreDataProperties)

+ (NSFetchRequest<AccountInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AccountInfo"];
}

@dynamic site_account;
@dynamic site_icon;
@dynamic site_name;
@dynamic site_password;
@dynamic bound_phone;
@dynamic bound_email;

@end
