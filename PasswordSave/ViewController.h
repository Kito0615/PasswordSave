//
//  ViewController.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/17.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FirstLoadViewController.h"
#import "MenuViewController.h"

#define ADMOB_APP_ID @"ca-app-pub-9800890094458111~2034463187"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *accField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UILabel *touchIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *touchIDButton;
- (IBAction)useTouchIDAction:(id)sender;

- (void)appWillEnterForeground;
- (void)appWillEnterBackground;

@end
