//
//  StudentModel.h
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/6.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "BQLDBModel.h"

#define StudentFile @"student.sqlite"

@interface StudentModel : BQLDBModel

@property (nonatomic) NSInteger stuid;          // 学号
@property (nonatomic, copy) NSString *name;     // 姓名
@property (nonatomic, copy) NSString *sex;      // 性别
@property (nonatomic) NSInteger age;            // 年龄
@property (nonatomic) double height;            // 身高

@end
