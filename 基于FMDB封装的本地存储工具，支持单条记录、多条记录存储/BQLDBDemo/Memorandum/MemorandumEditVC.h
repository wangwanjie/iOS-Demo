//
//  MemorandumEditVC.h
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/8.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "ViewController.h"
@class MemorandumModel;

// 分享类型
typedef NS_ENUM(NSInteger, EditType)
{
    EditTypeEdit = 0,   /**< 编辑备忘录    */
    EditTypeAdd         /**< 新增备忘录    */
};

@interface MemorandumEditVC : ViewController

@property (nonatomic, strong) MemorandumModel *model;
@property (nonatomic) EditType type;

@end
