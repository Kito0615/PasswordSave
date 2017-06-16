//
//  MenuViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "MenuViewController.h"

#define STATUS_BAR_HEIGHT 20
#define TABBAR_HEIGHT 49
#define DEFAULT_TAG_INCRESE 100
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface MenuViewController ()
{
    UIView * tabbar;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _initViewController];
        [self _initTabbarView];
    });
    
}

- (void)_initViewController
{
    _ptvc = [[PasswordTableViewController alloc] initWithNibName:@"PasswordTableViewController" bundle:[NSBundle mainBundle]];
    UINavigationController * ptnvc = [[UINavigationController alloc] initWithRootViewController:_ptvc];
    _gvc = [[GenerateViewController alloc] initWithNibName:@"GenerateViewController" bundle:[NSBundle mainBundle]];
    UINavigationController * gnvc = [[UINavigationController alloc] initWithRootViewController:_gvc];
    self.viewControllers = @[ptnvc, gnvc];
}

- (void)_initTabbarView
{
    tabbar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE.height - STATUS_BAR_HEIGHT - TABBAR_HEIGHT, SCREEN_SIZE.width, TABBAR_HEIGHT)];
    [self.view addSubview:tabbar];
    
    NSArray * backgound = @[@"keys", @"keyhole"];
    NSArray * titles = @[NSLocalizedString(@"passwords", nil), NSLocalizedString(@"generate", nil)];
    for (int i = 0; i < backgound.count; i ++) {
        UIViewController * vc = [self.viewControllers objectAtIndex:i];
        vc.tabBarItem.image = [UIImage imageNamed:backgound[i]];
        vc.tabBarItem.title = titles[i];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabbarAction:(UIButton *)btn
{
    self.selectedIndex = btn.tag - DEFAULT_TAG_INCRESE;
}

- (void)cleanAllData
{
    [_ptvc cleanAllData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
