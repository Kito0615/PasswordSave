//
//  DetailViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/19.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "DetailViewController.h"
#import "CoreDataManager.h"
#import "Base64Encoder.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
}

- (void)setupView
{
    self.nickNameField.text = [Base64Encoder base64DecodeStringFromData:self.info.site_account];
    self.siteIconView.image = [UIImage imageNamed:_info.site_icon];
    self.phoneField.text = self.info.bound_phone;
    self.emailField.text = self.info.bound_email;
    self.passwordField.text = [Base64Encoder base64DecodeStringFromData:self.info.site_password];
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

- (IBAction)editInfo:(UIButton *)sender {
    BOOL editting = NO;
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"edit", nil)]) {
        editting = YES;
    } else {
        editting = NO;
    }
    
    BOOL phoneEdit = (editting && self.phoneEditBtn == sender);
    self.phoneField.borderStyle = phoneEdit ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.phoneField.enabled = phoneEdit;
    [self.phoneField becomeFirstResponder];
    [self.phoneEditBtn setTitle:phoneEdit ? NSLocalizedString(@"done", nil) : NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    
    BOOL emailEdit = (editting && self.emailEditBtn == sender);
    self.emailField.borderStyle = emailEdit ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.emailField.enabled = emailEdit;
    [self.emailField becomeFirstResponder];
    [self.emailEditBtn setTitle:emailEdit ? NSLocalizedString(@"done", nil) : NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    
    BOOL pwdEdit = (editting && self.pwdEditBtn == sender);
    self.passwordField.borderStyle = pwdEdit ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.passwordField.enabled = pwdEdit;
    [self.passwordField becomeFirstResponder];
    [self.pwdEditBtn setTitle:pwdEdit ? NSLocalizedString(@"done", nil) : NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    self.passwordField.secureTextEntry = pwdEdit ? NO : YES;
    if (!(editting || phoneEdit || emailEdit || pwdEdit)) {
        [self.phoneField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        
        [self updateAccountInfo];
    }
}

- (void)updateAccountInfo
{
    NSLog(@"---->update");
    AccountInfoBridge * bridge = [[AccountInfoBridge alloc] init];
    bridge.site_account = [Base64Encoder base64EncodeStringToData:self.nickNameField.text];
    bridge.site_name = self.info.site_name;
    bridge.site_icon = self.info.site_icon;
    bridge.bound_phone = self.phoneField.text;
    bridge.bound_email = self.emailField.text;
    bridge.site_password = [Base64Encoder base64EncodeStringToData:self.passwordField.text];
    
    [DEFAULT_MANAGER updateData:@[bridge]];
}

- (void)showPasswordDirectly
{
    [self.passwordField setSecureTextEntry:NO];
}

@end
