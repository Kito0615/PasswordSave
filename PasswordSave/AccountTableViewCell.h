//
//  AccountTableViewCell.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ImageColor.h"

@interface AccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *siteIconView;
- (void)setIcon:(UIImage *)img;
@end
