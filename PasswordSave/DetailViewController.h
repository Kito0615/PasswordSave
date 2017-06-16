//
//  DetailViewController.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfoBridge.h"
#import "AccountInfo+CoreDataClass.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *phoneEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *pwdEditBtn;

@property (retain, nonatomic) AccountInfoBridge * info;
@property (weak, nonatomic) IBOutlet UIImageView *siteIconView;

- (IBAction)editInfo:(id)sender;

- (void)showPasswordDirectly;
@end
