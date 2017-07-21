//
//  BQLDBModel.h
//  BQLDB
//
//  Created by 毕青林 on 16/5/31.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
 注意:
 1:模型字段key全部小写
 2:转模型时,字典中若出现新的key数据库会自动识别为新增字段,并更新表
 3:id应为保留字段(数据库默认主键:id),因此模型中应尽量避免出现id为key的情况
 4:若真需要使用id作为key,请修改创建数据库语句,将id改为其他即可
 
 *******************************************************/

@interface BQLDBModel : NSObject

// 用户自定义主键(根据你的需求改下命名就行了如:studentID、memberID...)
@property (nonatomic, assign) int64_t customID;

/**
 * 根据字典来创建实例
 */
+ (instancetype )modelWithDictionary:(NSDictionary*)dictionary;

/**
 * 将实例转化为字典
 */
- (NSDictionary *)dictionaryWithModel;

/**
 * 获取所有key
 */
+ (NSArray *)getAllKeys;

/**
 * 获取所有key
 */
- (NSArray *)getAllKeys;

/**
 * 获取所有value
 */
- (NSArray *)getAllValues;

@end
