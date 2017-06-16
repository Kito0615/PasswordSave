//
//  AccountTableViewCell.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIcon:(UIImage *)img
{
    self.siteIconView.image = img;
    UIColor * mostColor = [UIColor mostColorFromImage:img];
    self.backgroundColor = [UIColor colorWithRed:mostColor.redComponent green:mostColor.greenComponent blue:mostColor.blueComponent alpha:0.1];
}

@end
