//
//  SettingsViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/6/7.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "SettingsViewController.h"
#import "NSDate+Formatter.h"
#import "CoreDataManager.h"
#import "Base64Encoder.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"setting", nil);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 32)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem = barItem;
    
    [self.exportButton setTitle:NSLocalizedString(@"export", nil) forState:UIControlStateNormal];
}

- (void)doneAction
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.75];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    
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

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

- (IBAction)exportAction:(UIButton *)sender {
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    for (NSString * path in files) {
        if ([path.pathExtension isEqualToString:@"txt"]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    NSString * exportFile = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ps_backup_%@.txt", [NSDate formatNow:@"yyyy_MM_dd_HH_mm_ss"]]];
    NSArray * infos = [[CoreDataManager sharedManager] selectAll];
    NSLog(@"---->File:%@", exportFile);
    for (AccountInfo * bridge in infos) {
        [self writeInfo:bridge toFile:exportFile];
    }
    if (iOS8Later) {
        UIAlertController * uac = [UIAlertController alertControllerWithTitle:@"Export Done" message:@"Export to local successed!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * uaa = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [uac addAction:uaa];
        [self presentViewController:uac animated:YES completion:^{
            
        }];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Export Done" message:@"Export to local successed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (BOOL)writeInfo:(AccountInfo *)info toFile:(NSString *)file
{
    NSMutableString * content = [NSMutableString string];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        [content appendString:[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil]];
    }
    [content appendFormat:@"-------Info of %@--------\n", info.site_name];
    [content appendFormat:@"User name : %@\n", [[NSString alloc] initWithData:info.site_account encoding:NSUTF8StringEncoding]];
    [content appendFormat:@"User password : %@\n", [[NSString alloc] initWithData:info.site_account encoding:NSUTF8StringEncoding]];
    [content appendFormat:@"User phone : %@\n", [Base64Encoder base64EncodeString:[NSString stringWithFormat:@"%@ account : %@", info.site_name, info.bound_phone]]];
    [content appendFormat:@"User email : %@\n", [Base64Encoder base64EncodeString:[NSString stringWithFormat:@"%@ password : %@", info.site_name, info.bound_email]]];
    
    return [content writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
