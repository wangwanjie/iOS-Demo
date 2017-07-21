//
//  MemorandumCell.h
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemorandumModel;

@interface MemorandumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteContent;
@property (weak, nonatomic) IBOutlet UILabel *noteTime;

@property (nonatomic, strong) MemorandumModel *model;

@end
