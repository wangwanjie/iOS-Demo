#import <objc/runtime.h>
#import <Foundation/Foundation.h>
static NSMutableDictionary *Myproperty;

@interface RunTime : NSObject

//获取单例
+ (NSMutableDictionary *)defaultMyproperty;
// 获取所有的属性名
+(NSArray *)allPropertiesFromObject:(id)object;
// 获取所有的属性名和Value
+ (NSDictionary *)allPropertyNamesAndValuesFromObject:(id)object;
// 获取所有的方法名
+ (NSArray *)allMethodsFromObject:(id)object;
// 获取所有的成员变量名
+ (NSArray *)allMemberVariablesFromObject:(id)object;
// 获取所有的属性类型
+ (NSArray *)allAtributesFromObject:(id)object;
// 获取所有的属性名和对应的类型
+ (NSDictionary *)allNameAndAtributesFromObject:(id)object;


//为类注册NSString;
+ (void)addNSStringPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSString *)String;
//为类注册NSMutableString;
+ (void)addNSMutableStringPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSMutableString *)MutableString;
//为类注册NSMutableArray;
+ (void)addNSMutableArrayPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSMutableArray *)MutableArray;
//为类注册NSArray;
+ (void)addNSArrayPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSArray *)NSArray;
//为类注册NSMutableDictionary;
+ (void)addNSMutableDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSMutableDictionary *)MutableDictionary;
//为类注册NSDictionary;
+ (void)addNSDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSDictionary *)Dictionary;

//获取类注册的NSString;
+ (NSString *)getNSStringPropertyToObject:(id)object withIdentify:(NSString *)identify;
//获取类注册的NSMutableString;
+ (NSMutableString *)getNSMutableStringPropertyToObject:(id)object withIdentify:(NSString *)identify;
//获取类注册的NSMutableArray;
+ (NSMutableArray *)getNSMutableArrayPropertyToObject:(id)object withIdentify:(NSString *)identify;
//获取类注册的NSArray;
+ (NSArray *)getNSArrayPropertyToObject:(id)object withIdentify:(NSString *)identify;
//获取类注册的NSMutableDictionary;
+ (NSMutableDictionary *)getNSMutableDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify;
//获取类注册的NSDictionary;
+ (NSDictionary *)getNSDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify;
@end
