#import <Foundation/Foundation.h>

@interface FMDBCreat : NSObject
//这个是通过运行时机制来生成的FMDB操作语句(用处也有,但是不大,需要编译器编译)
+ (NSDictionary *)GetNameAndAtributeFormObject:(id)model;
//辅助函数
+ (NSString *)getAtributes:(NSString *)text;
//1.1.如果一个模型里面全部都是字符串,根据这个模型生成  创建表格
+ (NSString *)ModelCreatTable:(NSDictionary *)propertyDic;
//1.2.如果一个模型里面全部都是字符串,根据这个模型生成  插入数据
+ (NSString *)ModelInsertData:(NSDictionary *)propertyDic;
//1.3.如果一个模型里面全部都是字符串,根据这个模型生成  读取数据
+ (NSString *)ModelReadData:(NSDictionary *)propertyDic;
//1.4.如果一个模型里面全部都是字符串,根据这个模型生成  删除表格
+ (NSString *)ModelDeleteData:(NSDictionary *)propertyDic;


//获取某一行属性声明中的属性名字和属性类型
+ (NSArray *)getNameAndAtributesFormLineText:(NSString *)lineText;
//去除头尾部的分号和空格
+ (NSString *)removeSpaceAndSemicolon:(NSString *)lineText;
//根据个数类获取换行的个数字符串
+ (NSString *)getTabSpaceWithTCount:(NSInteger)count;
//获取某个路径下所有的.h文件
+ (NSArray *)getAllFileNameWithPath:(NSString *)path;
//获取所有的字段名和字段类型
+ (NSDictionary *)getAllNameAndAtributesFromFilePath:(NSString *)filePath;
//获取类名
+ (NSString *)getClassNameFromFilePath:(NSString *)filePath;
//生成创建表格的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatTableNameFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM withInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
//生成读取数据的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatReadDataFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM  withInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
//生成插入数据的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatInsertDataFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM withInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
//生成删除表格中的数据的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatDeleteDatawithInsideValue:(NSInteger)tCount withClassName:(NSString *)className;



+ (NSString *)modelCreatInsertDataFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM withInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
+ (NSString *)modelCreatReadDataNoConditionsFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM  withInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
+ (NSString *)modelCreatReadDataHaveConditionsFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM  withInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
+ (NSString *)modelCreatDeleteDatawithInsideValue:(NSInteger)tCount withClassName:(NSString *)className;
+ (void)writeFileToModelWithFilePath:(NSString *)filePath;
+ (void)writeToFileWithFilePath:(NSString *)filePath;
//接口(生成的两个打包文件)
//- (void)insertDataToDataBaseWithObject:(id)object toDataBaseName:(NSString *)dataBaseName;
//- (id)readDataFromDataBaseToModelObject:(id)modelObject WithDataBaseName:(NSString *)dataBaseName;
//- (void)deleteDataFromDataBaseToModelObject:(id)modelObject WithDataBaseName:(NSString *)dataBaseName;


//生成的两个打包文件里面应该有的函数:
//- (void)creatTableNameWithModelObject:(id)object;
//- (id)getModelDataFromTableName:(NSString *)tableName;
//- (id)getModelDataFromDataBaseName:(NSString *)dataBaseName;
//- (void)deleteDataWithTableName:(NSString *)tableName;


//fmdb 解决方案:
//利用生成的.h文件来获取属性值,截取其中有用的信息
//将其生成对应的FMDB 插入 创建表 读取数据
/*
 要求写的函数有
 - ()
 */
@end