//
//  CustomCell.m
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void) setModel:(UserModel *)model {
    
    _model= model;
    _usernameLabel.text = model.username;
    _ageLabel.text = [NSString stringWithFormat:@"%d",model.age];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
