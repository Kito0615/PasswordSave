//
//  MenuViewController.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordTableViewController.h"
#import "GenerateViewController.h"

@interface MenuViewController : UITabBarController

@property (nonatomic, retain) PasswordTableViewController * ptvc;
@property (nonatomic, retain) GenerateViewController * gvc;

- (void)cleanAllData;

@end
