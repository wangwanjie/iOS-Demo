//
//  CustomCell.h
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property(nonatomic,strong) UserModel *model;

@end
