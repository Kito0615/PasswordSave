//
//  AddAccountViewController.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddAccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *siteField;
@property (weak, nonatomic) IBOutlet UIImageView *siteLogoView;
- (IBAction)doneAction:(id)sender;
- (IBAction)selectAction:(UIButton *)sender;
- (IBAction)showPassword:(id)sender;
@end
