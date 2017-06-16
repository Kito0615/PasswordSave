//
//  FirstLoadViewController.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

#define USE_TOUCHID_KEY @"UseTouchID"

@interface FirstLoadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *acccountField;
@property (weak, nonatomic) IBOutlet UITextField *accountPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

- (IBAction)createAction:(UIButton *)sender;
@end
