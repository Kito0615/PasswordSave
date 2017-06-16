//
//  AppDelegate.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/17.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ViewController * mainVC;

@property (nonatomic, assign) NSInteger signIndex;

@end

