//
//  GenerateViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "GenerateViewController.h"

typedef NS_ENUM(NSInteger, PasswordType) {
    PasswordTypeNone                    = 0,            // 0
    PasswordTypeDigits                  = 1 << 0,       // 1
    PasswordTypeLowerCharacters         = 1 << 1,       // 2
    PasswordTypeUpperCharacters         = 1 << 2,       // 4
    PasswordTypeSymbols                 = 1 << 3        // 8
};


@interface GenerateViewController ()<UITextFieldDelegate>

@end

@implementation GenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.passwordStartWithField.delegate = self;
    self.passwordEndWithField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkButton:(UIButton *)sender {
    
    [sender setSelected:!sender.isSelected];
    BOOL selected = sender.isSelected;
    NSString * imgName = selected ? @"checked" : @"unchecked";
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (IBAction)changePasswordLength:(UISlider *)sender {
    self.passwordLengthLabel.text = [[NSString alloc] initWithFormat:@"%.0f", sender.value];
}

- (IBAction)saveResultToClipboard:(UIButton *)sender {
    UIPasteboard * upb = [UIPasteboard generalPasteboard];
    [upb setString:self.resultView.text];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Copy Done!" message:@"Copy to pasteboard succeed!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    [self performSelector:@selector(alertDisappear:) withObject:alert afterDelay:1];
}

- (void)alertDisappear:(UIAlertView *)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

- (IBAction)generatePassword:(UIButton *)sender {
    NSInteger type = PasswordTypeNone;
    
    if (self.digitsCheck.isSelected)
        type |= PasswordTypeDigits;
    if (self.lowerCharactersCheck.isSelected)
        type |= PasswordTypeLowerCharacters;
    if (self.upCharactersCheck.isSelected)
        type |= PasswordTypeUpperCharacters;
    if (self.symbolCheck.isSelected)
        type |= PasswordTypeSymbols;
    
    NSString * prefix = self.passwordStartWithField.text.length ? self.passwordStartWithField.text : nil;
    NSString * suffix = self.passwordEndWithField.text.length ? self.passwordEndWithField.text : nil;
    
    NSString * password = [self generateResultWithOptions:type startWith:prefix endWith:suffix length:[self.passwordLengthLabel.text integerValue]];
    
    self.resultView.text = password;
    self.saveToClipboard.enabled = YES;
    
}

- (NSString *)generateResultWithOptions:(PasswordType)pwdType startWith:(NSString *)start endWith:(NSString *)end length:(NSInteger)length
{
    NSString * digitsString = @"0123456789";
    NSString * lowerCharacters = @"abcdefghijklmnopqrstuvwxyz";
    NSString * upperCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString * symbolsString = @"!@#$%^&*";
    
    NSString * pwdSrc = nil;
    
    if (pwdType == PasswordTypeNone) { // 0
        pwdSrc = @"";
    } else if (pwdType == PasswordTypeDigits) { // 1
        pwdSrc = digitsString;
    } else if (pwdType == PasswordTypeLowerCharacters) { // 2
        pwdSrc = lowerCharacters;
    } else if (pwdType == (PasswordTypeDigits | PasswordTypeLowerCharacters)) { // 3
        pwdSrc = [NSString stringWithFormat:@"%@%@", digitsString, lowerCharacters];
    } else if (pwdType == PasswordTypeUpperCharacters) { // 4
        pwdSrc = upperCharacters;
    } else if (pwdType == (PasswordTypeDigits | PasswordTypeUpperCharacters)) { // 5
        pwdSrc = [NSString stringWithFormat:@"%@%@", digitsString, upperCharacters];
    } else if (pwdType == (PasswordTypeLowerCharacters | PasswordTypeUpperCharacters)) { // 6
        pwdSrc = [NSString stringWithFormat:@"%@%@", lowerCharacters, upperCharacters];
    } else if (pwdType == (PasswordTypeDigits | PasswordTypeLowerCharacters | PasswordTypeUpperCharacters)) { // 7
        pwdSrc = [NSString stringWithFormat:@"%@%@%@", digitsString, lowerCharacters, upperCharacters];
    } else if (pwdType == PasswordTypeSymbols) { // 8
        pwdSrc = symbolsString;
    } else if (pwdType == (PasswordTypeDigits | PasswordTypeSymbols)) { // 9
        pwdSrc = [NSString stringWithFormat:@"%@%@", digitsString, symbolsString];
    } else if (pwdType == (PasswordTypeLowerCharacters | PasswordTypeSymbols)) { // 10
        pwdSrc = [NSString stringWithFormat:@"%@%@", lowerCharacters, symbolsString];
    } else if (pwdType == (PasswordTypeDigits | PasswordTypeLowerCharacters | PasswordTypeSymbols)){// 11
        pwdSrc = [NSString stringWithFormat:@"%@%@%@", digitsString, upperCharacters, symbolsString];
    } else if (pwdType == (PasswordTypeUpperCharacters | PasswordTypeSymbols)) { // 12
        pwdSrc = [NSString stringWithFormat:@"%@%@", upperCharacters, symbolsString];
    } else if (pwdType == (PasswordTypeLowerCharacters | PasswordTypeUpperCharacters | PasswordTypeSymbols)) { // 14
        pwdSrc = [NSString stringWithFormat:@"%@%@%@", lowerCharacters, upperCharacters, symbolsString];
    } else if (pwdType == (PasswordTypeDigits | PasswordTypeLowerCharacters | PasswordTypeUpperCharacters | PasswordTypeSymbols)) { // 15
        pwdSrc = [NSString stringWithFormat:@"%@%@%@%@", digitsString, lowerCharacters, upperCharacters, symbolsString];
    }
    NSMutableString * ret = [NSMutableString string];
    NSInteger generateLen = length;
    if (start) {
        [ret insertString:start atIndex:0];
        generateLen = generateLen - start.length;
    }
    if (end) {
        [ret insertString:end atIndex:start.length];
        generateLen = generateLen - end.length;
    }
    [ret insertString:[self generatePwdWith:pwdSrc length:generateLen] atIndex:start ? start.length : 0];
    return ret;
}

- (NSString *)generatePwdWith:(NSString *)srcString length:(NSInteger)length
{
    if (srcString.length == 0) {
        return srcString;
    }
    NSUInteger maxRandom = srcString.length;
    NSMutableString * ret = [NSMutableString string];
    for (int idx = 0; idx < length; idx ++) {
        NSInteger chIdx = arc4random() % maxRandom;
        char ch = [srcString characterAtIndex:chIdx];
        [ret appendFormat:@"%c", ch];
    }
    return ret;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
