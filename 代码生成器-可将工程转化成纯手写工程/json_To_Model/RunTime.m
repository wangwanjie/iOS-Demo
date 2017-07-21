#import "RunTime.h"
typedef struct objc_property *objc_property_t;
@implementation RunTime

//实现单例
+ (NSMutableDictionary *)defaultMyproperty{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(Myproperty ==nil){
            Myproperty=[NSMutableDictionary dictionary];
        }
    });
    return Myproperty;
}

//返回自己这个类的所有属性
- (NSArray *)allProperties {
    unsigned int count;
    // 获取类的所有属性
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        [propertiesArray addObject:name];
    }
    
    //     注意，这里properties是一个数组指针，是C的语法，
    //     我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    
    return propertiesArray;
}
//返回指定某个类的所有属性
+ (NSArray *)allPropertiesFromObject:(id)object{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [propertiesArray addObject:name];
    }
    free(properties);
    return propertiesArray;
}
//返回自己这个类的所有属性名和属性值
- (NSDictionary *)allPropertyNamesAndValues{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        
        // 得到属性名
        NSString *propertyName = [NSString stringWithUTF8String:name];
        
        // 获取属性值
        id propertyValue = [self valueForKey:propertyName];
        
        if (propertyValue && propertyValue != nil) {
            [resultDict setObject:propertyValue forKey:propertyName];
        }
    }
    
    // 记得释放
    free(properties);
    
    return resultDict;
}
//返回指定某个类的所有属性名和属性值
+ (NSDictionary *)allPropertyNamesAndValuesFromObject:(id)object{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    NSLog(@"%d",outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        // 得到属性名
        NSString *propertyName = [NSString stringWithUTF8String:name];
        // 获取属性值
        id propertyValue = [object valueForKey:propertyName];
        if (propertyName && propertyValue != nil) {
            NSLog(@"%@",propertyName);
            [resultDict setObject:propertyValue forKey:propertyName];
        }
    }
    // 记得释放
    free(properties);
    return resultDict;
}
//返回自己这个类的所有方法名
- (void)allMethods {
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([self class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        Method method = methods[i];
        // 获取方法名称，但是类型是一个SEL选择器类型
        SEL methodSEL = method_getName(method);
        // 需要获取C字符串
        const char *name = sel_getName(methodSEL);
        // 将方法名转换成OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];
        // 获取方法的参数列表
        int arguments = method_getNumberOfArguments(method);
        NSLog(@"方法名：%@, 参数个数：%d", methodName, arguments);
    }
    // 记得释放
    free(methods);
}
//返回指定某个类的所有方法名
+ (NSArray *)allMethodsFromObject:(id)object{
    NSMutableArray *methodArr=[NSMutableArray array];
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([object class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        Method method = methods[i];
        // 获取方法名称，但是类型是一个SEL选择器类型
        SEL methodSEL = method_getName(method);
        // 需要获取C字符串
        const char *name = sel_getName(methodSEL);
        // 将方法名转换成OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];
        [methodArr addObject:methodName];
        // 获取方法的参数列表
//        int arguments = method_getNumberOfArguments(method);
//        NSLog(@"方法名：%@, 参数个数：%d", methodName, arguments);
    }
    // 记得释放
    free(methods);
    return methodArr;
}
//返回自己这个类的所有成员变量
- (NSArray *)allMemberVariables{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; ++i) {
        Ivar variable = ivars[i];
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        [results addObject:varName];
    }
    return results;
}
//返回指定某个类的所有成员变量
+ (NSArray *)allMemberVariablesFromObject:(id)object{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([object class], &count);
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; ++i) {
        Ivar variable = ivars[i];
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        [results addObject:varName];
    }
    return results;
}
+ (NSArray *)allAtributesFromObject:(id)object{
    unsigned int count;
    NSMutableArray *allAtributesArr=[NSMutableArray array];
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
//        NSLog(@"name:%s",property_getName(property));
        [allAtributesArr addObject:[NSString stringWithUTF8String:property_getAttributes(property)]];
//        NSLog(@"attributes:%s",property_getAttributes(property));
        
    }
    free(properties);
    return allAtributesArr;
}
// 获取所有的属性名和对应的类型
+ (NSDictionary *)allNameAndAtributesFromObject:(id)object{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        [dicM setValue:[NSString stringWithUTF8String:property_getAttributes(property)] forKey:[NSString stringWithUTF8String:property_getName(property)]];
        //        NSLog(@"name:%s",property_getName(property));
        //        NSLog(@"attributes:%s",property_getAttributes(property));
    }
    free(properties);
    return dicM;
}


//为类注册属性

//可以使用字典来存储某个属性字段的标识符,通过将属性标识符转换成C字符串来实现标志的效果,而且还可以做到将字典对应Key值得搜索方式

//辅助方法
//判断单例字典里是否含有某个value值
+ (BOOL)singleCategroyHasValue:(NSString *)value{
    for (NSString *myValue in [[RunTime defaultMyproperty]allValues]) {
        if([myValue isEqualToString:value])
            return YES;
    }
    return NO;
}
+ (NSString *)getUniqueSValueString{
    NSString *myValue=[NSString stringWithFormat:@"%d",arc4random()];
    while([RunTime singleCategroyHasValue:myValue]==YES){
        myValue=[NSString stringWithFormat:@"%d",arc4random()];
    }
    return myValue;
}
+ (NSString *)getFlagValueWithIdentity:(NSString *)identity{
    if([RunTime defaultMyproperty][identity]!=nil)
        return [RunTime defaultMyproperty][identity];
    return @"";
}


//为类注册NSString;
+ (void)addNSStringPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSString *)String{
    //先把Identify写到字典中
    [[RunTime defaultMyproperty]setValue:[RunTime getUniqueSValueString] forKey:identify];
    objc_setAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String], String, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//为类注册NSMutableString;
+ (void)addNSMutableStringPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSMutableString *)MutableString{
    //先把Identify写到字典中
    [[RunTime defaultMyproperty]setValue:[RunTime getUniqueSValueString] forKey:identify];
    objc_setAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String], MutableString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//为类注册NSMutableArray;
+ (void)addNSMutableArrayPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSMutableArray *)MutableArray{
    //先把Identify写到字典中
    [[RunTime defaultMyproperty]setValue:[RunTime getUniqueSValueString] forKey:identify];
    objc_setAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String], MutableArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//为类注册NSArray;
+ (void)addNSArrayPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSArray *)NSArray{
    //先把Identify写到字典中
    [[RunTime defaultMyproperty]setValue:[RunTime getUniqueSValueString] forKey:identify];
    objc_setAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String], NSArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//为类注册NSMutableDictionary;
+ (void)addNSMutableDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSMutableDictionary *)MutableDictionary{
    //先把Identify写到字典中
    [[RunTime defaultMyproperty]setValue:[RunTime getUniqueSValueString] forKey:identify];
    objc_setAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String], MutableDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//为类注册NSDictionary;
+ (void)addNSDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify withValue:(NSDictionary *)Dictionary{
    //先把Identify写到字典中
    [[RunTime defaultMyproperty]setValue:[RunTime getUniqueSValueString] forKey:identify];
    objc_setAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String], Dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//获取类注册的NSString;
+ (NSString *)getNSStringPropertyToObject:(id)object withIdentify:(NSString *)identify{
    return objc_getAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String]);
}
//获取类注册的NSMutableString;
+ (NSMutableString *)getNSMutableStringPropertyToObject:(id)object withIdentify:(NSString *)identify{
    return objc_getAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String]);
}
//获取类注册的NSMutableArray;
+ (NSMutableArray *)getNSMutableArrayPropertyToObject:(id)object withIdentify:(NSString *)identify{
    return objc_getAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String]);
}
//获取类注册的NSArray;
+ (NSArray *)getNSArrayPropertyToObject:(id)object withIdentify:(NSString *)identify{
    return objc_getAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String]);
}
//获取类注册的NSMutableDictionary;
+ (NSMutableDictionary *)getNSMutableDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify{
    return objc_getAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String]);
}
//获取类注册的NSDictionary;
+ (NSDictionary *)getNSDictionaryPropertyToObject:(id)object withIdentify:(NSString *)identify{
    return objc_getAssociatedObject(object, [[RunTime getFlagValueWithIdentity:identify]UTF8String]);
}

@end
