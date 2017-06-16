//
//  AddAccountViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "AddAccountViewController.h"
#import "AccountInfoBridge.h"
#import "Base64Encoder.h"
#import "CoreDataManager.h"
#import "NSString+Localization.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface AddAccountViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>
{
    NSArray * pickList;
    UIPickerView * picker;
    UIView * shadowView;
    NSString * iconName;
    NSString * saveName;
}

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"addAccount", nil);
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"site_icon" ofType:@"plist"];
    pickList = [NSArray arrayWithContentsOfFile:path];
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

- (IBAction)doneAction:(id)sender {
    
    if (self.accountField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"please enter account", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
        return;
    } else if (self.passwordField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"please enter password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
        return;
    }    
    [self saveToData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldResignFirstResponder
{
    [self.accountField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)selectAction:(UIButton *)sender {
    [self textFieldResignFirstResponder];
    CGRect bds = self.view.bounds;
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, bds.size.height, bds.size.width, bds.size.height / 2)];
    picker = [[UIPickerView alloc] initWithFrame:shadowView.bounds];
    [picker setDelegate:self];
    [picker setDataSource:self];
    UIColor * bgColor = [UIColor lightGrayColor];
    bgColor = [UIColor colorWithWhite:0.667 alpha:0.5];
    shadowView.backgroundColor = bgColor;
    
    
    [shadowView addSubview:picker];
    [self.view addSubview:shadowView];
    
    [UIView animateWithDuration:0.5 animations:^{
        shadowView.frame = CGRectMake(0, bds.size.height / 2, bds.size.width, bds.size.height / 2);
    }];
}

- (IBAction)showPassword:(UIButton *)sender {
    BOOL isSecure = [self.passwordField isSecureTextEntry];
    [sender setTitle:isSecure ? NSLocalizedString(@"hide", nil) : NSLocalizedString(@"show", nil) forState:UIControlStateNormal];
    [self.passwordField setSecureTextEntry:!isSecure];
}

- (void)saveToData
{
    AccountInfoBridge * info = [[AccountInfoBridge alloc] init];
    info.site_account = [Base64Encoder base64EncodeStringToData:self.accountField.text];
    info.site_password = [Base64Encoder base64EncodeStringToData:self.passwordField.text];
    info.bound_phone = self.phoneField.text;
    info.bound_email = self.emailField.text;
    info.site_name = saveName;
    info.site_icon = iconName;
    
    [DEFAULT_MANAGER insertCoreData:@[info]];
}

#pragma mark -UIAlertViewDelegate
- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self saveToData];
}


#pragma mark -UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickList.count;
}
#pragma mark -UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_SIZE.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString * key = [[NSString preferedLanguageCode] isEqualToString:@"zh-Hans-CN"] ? @"site_cn" : @"site";
    saveName = [[pickList objectAtIndex:row] objectForKey:@"site"];
    self.siteField.text = [[pickList objectAtIndex:row] objectForKey:key];
    iconName = [[pickList objectAtIndex:row] objectForKey:@"icon"];
    self.siteLogoView.image = [UIImage imageNamed:iconName];
    [pickerView removeFromSuperview];
    [shadowView removeFromSuperview];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * labe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 20)];
    NSDictionary * item = [pickList objectAtIndex:row];
    NSString * key = [[NSString preferedLanguageCode] isEqualToString:@"zh-Hans-CN"] ? @"site_cn" : @"site";
    labe.text = [item objectForKey:key];
    labe.textAlignment = NSTextAlignmentCenter;
    return labe;
}
@end
