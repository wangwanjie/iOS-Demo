//
//  MemorandumModel.h
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "BQLDBModel.h"

#define MemorandumFile @"Memorandum.sqlite"

@interface MemorandumModel : BQLDBModel

@property (nonatomic, copy) NSString *notecontent;  // 备忘录内容
@property (nonatomic, copy) NSString *notetime;     // 备忘录时间

@end
