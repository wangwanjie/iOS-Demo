//
//  CreatCoreData.h
//  JsonAutoCreatProperty
//
//  Created by mac on 12-11-3.
//  Copyright (c) 2012年 com/ZH/mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatCoreData : NSObject

+ (NSMutableString *)RemoveRepeat:(NSString *)strM;
+ (NSArray *)GetTransformable:(NSString *)strM;
//1.生成Integer 32
+ (void)addIntegerCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//2.生成Binary
+ (void)addBinaryCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//3.生成Date
+ (void)addDateCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//4.生成Float
+ (void)addFloatCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//5.生成String
+ (void)addStringCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//6.生成Transformable
+ (void)addTransformableCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//7.生成Entity<entity name="Entity" syncable="YES">
+ (void)addEntityCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//8.生成</entity>
+ (void)addReEntityCoreDataToNSMutableString:(NSMutableString *)StrM;
//9.生成<elements>
+ (void)addEntitysCoreDataToNSMutableString:(NSMutableString *)StrM;
//9.1生成<element>
+ (void)addElementCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name;
//10.生成</elements>
+ (void)addReEntitysCoreDataToNSMutableString:(NSMutableString *)StrM;
//11.生成</model>
+ (void)addReModelCoreDataToNSMutableString:(NSMutableString *)StrM;



//1.生成Attribute
+ (void)addAttributeCoreDataToNSMutableString:(NSMutableString *)StrM;
//2.生成Name
+ (void)addNameCoreDataToNSMutableString:(NSMutableString *)StrM withName:(NSString *)name;
//3.生成Optional
+ (void)addOptionalCoreDataToNSMutableString:(NSMutableString *)StrM;
//4.生成AttributeType
+ (void)addAttributeTypeCoreDataToNSMutableString:(NSMutableString *)StrM withAttributeType:(NSString *)attributeType;
//5.生成DefaultValue
+ (void)addDefaultValueStringCoreDataToNSMutableString:(NSMutableString *)StrM withIntOrFloat:(BOOL)Int;
//6.生成Syncable
+ (void)addSyncableCoreDataToNSMutableString:(NSMutableString *)StrM;

//1.导入头数据
+ (void)addXMLinfoToNSMutableString:(NSMutableString *)StrM;



//导入辅助函数
//1.导入NSManagedObjectContext
+ (void)addNSManagedObjectContextToNSMutableString:(NSMutableString *)StrM;
//2.1导入AppDelegate.h
+ (void)addHeadFileToNSMutableString:(NSMutableString *)StrM;
//3.1插入数据
+ (void)insertDataToNSMutableString:(NSMutableString *)StrM;
//3.2修改数据
+ (void)updataDataToNSMutableString:(NSMutableString *)StrM;
//3.3删除数据
+ (void)deleteDataToNSMutableString:(NSMutableString *)StrM;
//3.4查询数据
+ (void)searchDataToNSMutableString:(NSMutableString *)StrM;
//4添加查询数据库
+ (void)addSearchFromDatabaseToNSMutableString:(NSMutableString *)StrM;

@end
