//
//  GenerateViewController.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenerateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *passwordLengthSlider;
@property (weak, nonatomic) IBOutlet UILabel *passwordLengthLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordStartWithField;
@property (weak, nonatomic) IBOutlet UITextField *passwordEndWithField;
@property (weak, nonatomic) IBOutlet UIButton *digitsCheck;
@property (weak, nonatomic) IBOutlet UIButton *lowerCharactersCheck;
@property (weak, nonatomic) IBOutlet UIButton *upCharactersCheck;
@property (weak, nonatomic) IBOutlet UIButton *symbolCheck;

@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (weak, nonatomic) IBOutlet UIButton *saveToClipboard;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

- (IBAction)checkButton:(UIButton *)sender;

- (IBAction)changePasswordLength:(id)sender;
- (IBAction)saveResultToClipboard:(id)sender;
- (IBAction)generatePassword:(id)sender;

@end
