//
//  FirstLoadViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "FirstLoadViewController.h"
#import "KeychainWrapper.h"

@interface FirstLoadViewController ()<UIAlertViewDelegate>
{
    UIAlertView * touchIDAlert;
    LAContext * localAuth;
}

@end

@implementation FirstLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createAction:(UIButton *)sender {
    
    [self.accountPassword resignFirstResponder];
    [self.acccountField resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    
    NSString * acc = self.acccountField.text;
    NSString * pwd1 = self.accountPassword.text;
    NSString * pwd2 = self.confirmPassword.text;
    if ([acc length] && [pwd1 length] && [pwd2 length] &&[pwd1 isEqualToString:pwd2]) {
        // Create account.
        [KeychainWrapper save:SERVICE_ACCOUNT_KEY data:[acc dataUsingEncoding:NSUTF8StringEncoding]];
        [KeychainWrapper save:SERVICE_PASSWORD_KEY data:[pwd1 dataUsingEncoding:NSUTF8StringEncoding]];
        localAuth = [[LAContext alloc] init];
        if ([localAuth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            touchIDAlert = [[UIAlertView alloc] initWithTitle:@"Active TouchID" message:@"Use TouchID to access this App" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [touchIDAlert show];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } else if (![acc length]) {
        [self showAlertTitle:@"No Account name" info:@"Please check account field input."];
    } else if (![pwd1 length] || ![pwd2 length]) {
        [self showAlertTitle:@"No password" info:@"Please check password field input."];
    } else if (![pwd1 isEqualToString:pwd2]) {
        [self showAlertTitle:@"Confirm password" info:@"Please confirm your password."];
    }
    
}

- (void)showAlertTitle:(NSString *)title info:(NSString *)info
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [localAuth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Save password more safe" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self showAlertTitle:@"TouchID set success" info:@"Success"];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USE_TOUCHID_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                if (error.code == -2) {
                    NSLog(@"---->Canceled.");
                } else if (error.code == -3) {
                    NSLog(@"---->Input password.");
                } else if (error.code == -1) {
                    NSLog(@"---->Validate 3 times error.");
                } else if (error.code == -4) {
                    NSLog(@"---->Pressed power button.");
                } else if (error.code == -8) {
                    NSLog(@"---->TouchID been locked.");
                }
                NSLog(@"----->TouchID Failed.");
            }
        }];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
