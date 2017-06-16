//
//  ViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/17.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "ViewController.h"
#import "KeychainWrapper.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <UIAlertViewDelegate>
{
    UIVisualEffectView * blurView;
    FirstLoadViewController * flvc;
    MenuViewController * mvc;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.mainVC = self;
    
    [GADMobileAds configureWithApplicationID:ADMOB_APP_ID];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![KeychainWrapper load:SERVICE_ACCOUNT_KEY]) {
        flvc = [[FirstLoadViewController alloc] initWithNibName:@"FirstLoadViewController" bundle:[NSBundle mainBundle]];
        [self presentViewController:flvc animated:YES completion:^{
            
        }];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:USE_TOUCHID_KEY]) {
        [self useTouchIDAction:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USE_TOUCHID_KEY]) {
        self.touchIDLabel.hidden = YES;
        self.touchIDButton.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAction:(id)sender {
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (sender == nil) {
        mvc = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
        [self setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:mvc animated:YES completion:^{
            [[self.view window] setRootViewController:mvc];
            if (delegate.signIndex == -1) {
                mvc.selectedIndex = 0;
                [mvc.ptvc createNewAccount];
            } else {
                mvc.selectedIndex = delegate.signIndex;
            }
        }];
    } else {
        [self.accField resignFirstResponder];
        [self.pwdField resignFirstResponder];
        
        NSData * accData = [KeychainWrapper load:SERVICE_ACCOUNT_KEY];
        NSData * pwdData = [KeychainWrapper load:SERVICE_PASSWORD_KEY];
        NSString * acc = [[NSString alloc] initWithData:accData encoding:NSUTF8StringEncoding];
        NSString * pwd = [[NSString alloc] initWithData:pwdData encoding:NSUTF8StringEncoding];
        
        NSString * inputAcc = [self.accField text];
        NSString * inputPwd = [self.pwdField text];
        if ([inputAcc isEqualToString:acc] && [inputPwd isEqualToString:pwd]) {
            mvc = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
            [self setModalPresentationStyle:UIModalPresentationPageSheet];
            [self presentViewController:mvc animated:YES completion:^{
                [[self.view window] setRootViewController:mvc];
                if (delegate.signIndex == -1) {
                    mvc.selectedIndex = 0;
                    [mvc.ptvc createNewAccount];
                } else {
                    mvc.selectedIndex = delegate.signIndex;
                }
            }];
        }
    }
}

- (void)showAlert:(NSString *)title info:(NSString *)info
{
    [[[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)cleanKeyChain:(id)sender {
    
    [[[UIAlertView alloc] initWithTitle:@"Warning..." message:@"Are you sure to erase all account info?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", @"Keep Info", nil] show];
}

- (IBAction)useTouchIDAction:(id)sender {
    
    LAContext * auth = [[LAContext alloc] init];
    if (![auth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [self showAlert:@"TouchID Error" info:@"Your device not support TouchID"];
    } else {
        [auth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Use TouchID to login" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                [self loginAction:nil];
            }
        }];
    }
}

- (void)appWillEnterForeground
{
    if (blurView) {
        [blurView removeFromSuperview];
    }
    [mvc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)appWillEnterBackground
{
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [blurView setFrame:mvc.view.bounds];
    [mvc.view addSubview:blurView];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [KeychainWrapper delete:SERVICE_PASSWORD_KEY];
        [KeychainWrapper delete:SERVICE_ACCOUNT_KEY];
        [mvc cleanAllData];
    } else if (buttonIndex == 2) {
        [KeychainWrapper delete:SERVICE_PASSWORD_KEY];
        [KeychainWrapper delete:SERVICE_ACCOUNT_KEY];
    }
}
@end
