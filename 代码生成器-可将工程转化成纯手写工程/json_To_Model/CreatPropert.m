#import "CreatPropert.h"
#import "CreatCoreData.h"

//实现自动根据里面的类型自动生成属性

int judge(char *p){
    printf("数字为:%s\n",p);
    char *s=p;
    int flag=-1;
    //判断里面是否含有小数点
    while (*s!='\0') {
        if(*s=='.')
            flag=2;//2代表浮点数
        else if(!(*s>='0'&&*s<='9')){
            flag=3;//3代表出错
            NSLog(@"plist说的nsnumber里面含有非数字");
        }
        s++;
    }
    if(flag==-1)flag=1;//3代表成功
    return flag;
}

@implementation CreatPropert

//辅助函数KVC
//属性值property的生成
+ (void)myNSArray:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSArray *%@;\n",tempStr];
}
+ (void)myNSMutableArray:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSMutableArray *My%@;\n",tempStr];
}
+ (void)myNSDictionary:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSDictionary *%@;\n",tempStr];
}
+ (void)myNSMutableDictionary:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSMutableDictionary *My%@;\n",tempStr];
}
+ (void)myNSData:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSData %@;\n",tempStr];
}
+ (void)myNSNumberInt:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,assign)int %@;\n",tempStr];
}
+ (void)myNSNumberFloat:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,assign)float %@;\n",tempStr];
}
+ (void)myNSNull:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSNull *%@;\n",tempStr];
}
+ (void)myNSDate:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,strong)NSDate %@;\n",tempStr];
}
+ (void)myNSString:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendFormat:@"@property (nonatomic,copy)NSString *%@;\n",tempStr];
}

//新增点语法支持  :(函数)
//将字典转换成属性
+ (void)myNSDictionaryTransformToPropert:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM withModelName:(NSString *)modelName{
    [StrM appendFormat:@"@property (nonatomic,strong)%@%@Model *My%@;\n",modelName,tempStr,tempStr];
}

//辅助函数JSONModel
//属性NSMutableArray并且带协议
+ (void)myNSMutableArrayJSONModelToNSMutableString:(NSMutableString *)StrM withArrNames:(NSArray *)arrNames withArrSpecialNames:(NSArray *)arrSpecialNames withModelName:(NSString *)modename{
    for (NSString *tempStr in arrNames) {
        [StrM appendString:@"@property (nonatomic,strong)NSMutableArray <"];
        [StrM appendString:modename];
        [StrM appendString:tempStr];
        [StrM appendString:@"Model"];
        [StrM appendString:@"> *My"];
        [StrM appendString:tempStr];
        [StrM appendString:@";\n"];
    }
    for (NSString *tempStr in arrSpecialNames) {
        [StrM appendString:@"@property (nonatomic,strong)NSMutableArray *My"];
        [StrM appendString:tempStr];
        [StrM appendString:@";\n"];
    }
}
//属性NSDictionary并且带协议
+ (void)myNSMutableDictionaryJSONModel:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"@property (nonatomic,strong)NSDictionary <"];
    [StrM appendString:tempStr];
    [StrM appendString:@"Model"];
    [StrM appendString:@"> *My"];
//    [StrM appendString:@"@property (nonatomic,strong)NSDictionary"];
//    [StrM appendString:@" *My"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}

//生产coreData的text
static NSMutableString *coreDataText;
static int primeArr=NO;

//将所有内容写到一个文件里面
static NSMutableString *staticText_h;
static NSMutableString *staticText_m;

+ (void)clearTextWithModelName:(NSString *)modelName withGiveData:(NSInteger)category{
    if(staticText_h==nil)staticText_h=[NSMutableString string];
    [staticText_h setString:@""];
    if(staticText_m==nil)staticText_m=[NSMutableString string];
    [staticText_m setString:@""];
    [self addModelHFileWithModelName:modelName withGiveData:category];
}
+ (void)saveTextWithModelName:(NSString *)modelName savePath:(NSString *)savePath{
    [staticText_h writeToFile:[savePath stringByAppendingFormat:@"%@Model.h",modelName]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [staticText_m writeToFile:[savePath stringByAppendingFormat:@"%@Model.m",modelName]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//字典创建模型的主要函数
+ (void)creatProperty:(id)obj fileName:(NSString *)fileName WithContext:(NSString *)context savePath:(NSString *)savePath withNSNULL:(BOOL)NSNULL withNSDATE:(BOOL)NSDATE withNSNUMBER:(BOOL)NSNUMBER withGiveData:(NSInteger)category withModelName:(NSString *)modelName withFatherClass:(NSString *)className needEcoding:(BOOL)ecoding{
    
    NSMutableString *str=[NSMutableString string];//创建文本
    
    NSMutableString *coreStr=[NSMutableString string];//创建文本
    
    if(coreDataText==nil)coreDataText=[NSMutableString string];
    if([coreDataText rangeOfString:@"</model>"].location!=NSNotFound){
        [coreDataText setString:@""];
    }
    
    NSMutableArray *arrName=[NSMutableArray new];
    
    NSMutableArray *arrSpecialName=[NSMutableArray new];
    
    NSMutableArray *arrNameJSONModel=[NSMutableArray new];
    
    NSMutableArray *arrSpecialNameJSONModel=[NSMutableArray new];
    
    NSMutableArray *dicName=[NSMutableArray new];
    
    NSMutableArray *stringArr=[NSMutableArray new];
    
    NSMutableArray *NSArrayOrDictionaryArr=[NSMutableArray new];
    
    NSMutableArray *intArr=[NSMutableArray new];
    
    NSMutableArray *floatArr=[NSMutableArray new];
    
    //将头数据导入进来
    if([fileName isEqualToString:modelName]&&primeArr==0){
        [CreatCoreData addXMLinfoToNSMutableString:coreDataText];
    }
    
    [CreatCoreData addEntityCoreDataToNSMutableString:coreStr withName:fileName];
    
    if([fileName isEqualToString:modelName]==NO){
        if(category==1)
            fileName=[modelName stringByAppendingString:fileName];
        else{
            fileName=[modelName stringByAppendingString:fileName];
        }
    }
    
    if([obj isKindOfClass:[NSDictionary class]]){//如果obj对象是字典
        
        primeArr++;
        for (id objtemp in obj) {//开始遍历字典里面的键值对
            if([obj[objtemp] isKindOfClass:[NSString class]]){//如果字典里面是字符串
                //这里需要进行一定的排除 id description
                
                [self myNSString:[self specialNSString:objtemp] ToNSMutableString:str];
                [CreatCoreData addStringCoreDataToNSMutableString:coreStr withName:[self specialNSString:objtemp]];
                [stringArr addObject:[self specialNSString:objtemp]];
            }
            else if([obj[objtemp] isKindOfClass:[NSArray class]]){//如果字典里面是数组
                if(category==3){//原样输出
                    
                    [self myNSArray:objtemp ToNSMutableString:str];
                    [CreatCoreData addTransformableCoreDataToNSMutableString:coreStr withName:objtemp];
                    
                }else if(category==1){//KVC模式
                    if(((NSArray *)obj[objtemp]).count>0&&[((NSArray *)obj[objtemp])[0] isKindOfClass:[NSDictionary class]] ){//判断里面的数组中是不是字典
                        [arrName addObject:objtemp];
                    }else{
                        [arrSpecialName addObject:objtemp];
                    }
                    
                    [NSArrayOrDictionaryArr addObject:[@"NSArray" stringByAppendingString:(NSString *)(objtemp)]];
                    
                    [self myNSMutableArray:objtemp ToNSMutableString:str];
                    [CreatCoreData addTransformableCoreDataToNSMutableString:coreStr withName:objtemp];
                    
                }else if(category==2){//JSONModel模式
                    if(((NSArray *)obj[objtemp]).count>0&&[((NSArray *)obj[objtemp])[0] isKindOfClass:[NSDictionary class]] ){//判断里面的数组中是不是字典
                        if([arrName containsObject:objtemp]==NO)
                            [arrName addObject:objtemp];
                        if([arrNameJSONModel containsObject:objtemp]==NO)
                            [arrNameJSONModel addObject:objtemp];
                    }else{
                        if([arrSpecialName containsObject:objtemp]==NO)
                            [arrSpecialName addObject:objtemp];
                        if([arrSpecialNameJSONModel containsObject:objtemp]==NO)
                            [arrSpecialNameJSONModel addObject:objtemp];
                    }
                    
                    [NSArrayOrDictionaryArr addObject:[@"NSArray" stringByAppendingString:(NSString *)(objtemp)]];
//                    [NSArrayOrDictionaryArr addObject:objtemp];
                    
                    [self myNSMutableArrayJSONModelToNSMutableString:str withArrNames:[arrNameJSONModel copy] withArrSpecialNames:[arrSpecialNameJSONModel copy] withModelName:modelName];
                    [CreatCoreData addTransformableCoreDataToNSMutableString:coreStr withName:objtemp];
                    
                    //清除旧数据,以免多线程因素引起重复的属性
                    [arrNameJSONModel removeAllObjects];
                    [arrSpecialNameJSONModel removeAllObjects];
                }
                
                NSString *tempFileName=objtemp;
                [self creatProperty:obj[objtemp] fileName:tempFileName WithContext:objtemp savePath:savePath withNSNULL:NSNULL withNSDATE:NSDATE withNSNUMBER:NSNUMBER withGiveData:category withModelName:modelName withFatherClass:@"NSDictionary" needEcoding:ecoding];
                
            }
            else if ([obj[objtemp] isKindOfClass:[NSDictionary class]]){//如果字典里面是字典
                if(category==3){
                
                    [self myNSDictionaryTransformToPropert:objtemp ToNSMutableString:str withModelName:modelName];
//                    [self myNSDictionary:objtemp ToNSMutableString:str];
                    [CreatCoreData addTransformableCoreDataToNSMutableString:coreStr withName:objtemp];
                    
                }else if(category==1){
                    
                    [dicName addObject:objtemp];
                    [NSArrayOrDictionaryArr addObject:[@"NSDictionary" stringByAppendingString:(NSString *)(objtemp)]];
//                    [NSArrayOrDictionaryArr addObject:objtemp];
                    [self myNSDictionaryTransformToPropert:objtemp ToNSMutableString:str withModelName:modelName];
//                    [self myNSMutableDictionary:objtemp ToNSMutableString:str];
                    [CreatCoreData addTransformableCoreDataToNSMutableString:coreStr withName:objtemp];
                    
                }else if(category==2){
                    
                    [dicName addObject:objtemp];
                    [NSArrayOrDictionaryArr addObject:[@"NSDictionary" stringByAppendingString:(NSString *)(objtemp)]];
//                    [NSArrayOrDictionaryArr addObject:objtemp];
                    [self myNSDictionaryTransformToPropert:objtemp ToNSMutableString:str withModelName:modelName];
//                    [self myNSMutableDictionaryJSONModel:objtemp ToNSMutableString:str];
                    [CreatCoreData addTransformableCoreDataToNSMutableString:coreStr withName:objtemp];
                }
                
                NSString *tempFileName=objtemp;
                [self creatProperty:obj[objtemp] fileName:tempFileName WithContext:objtemp savePath:savePath withNSNULL:NSNULL withNSDATE:NSDATE withNSNUMBER:NSNUMBER withGiveData:category withModelName:modelName withFatherClass:@"NSDictionary" needEcoding:ecoding];
            }
            else if ([obj[objtemp] isKindOfClass:[NSNull class]]){//如果字典里面是nsnull
                
                if(NSNULL==NO){
                    //这里需要注意,假如文本里面是空,可能会被当做成NSNull
                    [self myNSNull:objtemp ToNSMutableString:str];
                }else{
                    [self myNSString:[self specialNSString:objtemp] ToNSMutableString:str];
                    [CreatCoreData addStringCoreDataToNSMutableString:coreStr withName:[self specialNSString:objtemp]];
                    [stringArr addObject:[self specialNSString:objtemp]];
                }
                
            }
            else if([obj[objtemp] isKindOfClass:[NSNumber class]]){//如果字典里面是NSNumber
                
                if(NSNUMBER==NO){
                    //这里需要对里面的值进行判断
                    NSNumber *num=obj[objtemp];
                    NSString *strNum=[num stringValue];//将NSNumber转换成字符串
                    
                    char *strP=[strNum UTF8String];
                    int value_int;float value_float;
                    switch (judge(strP)) {
                        case 1:value_int=[num intValue];
                            [self myNSNumberInt:objtemp ToNSMutableString:str];
                            [CreatCoreData addIntegerCoreDataToNSMutableString:coreStr withName:objtemp];
                            [intArr addObject:objtemp];
                            break;
                        case 2:value_float=[num floatValue];
                            [self myNSNumberFloat:objtemp ToNSMutableString:str];
                            [CreatCoreData addFloatCoreDataToNSMutableString:coreStr withName:objtemp];
                            [floatArr addObject:objtemp];
                            break;
                    }
                }else{
                    [self myNSString:[self specialNSString:objtemp] ToNSMutableString:str];
                    [CreatCoreData addStringCoreDataToNSMutableString:coreStr withName:[self specialNSString:objtemp]];
                    [stringArr addObject:[self specialNSString:objtemp]];
                }
            }
            else if([obj[objtemp] isKindOfClass:[NSData class]]){//如果字典里面是NSData
                
                [self myNSData:objtemp ToNSMutableString:str];
                [CreatCoreData addBinaryCoreDataToNSMutableString:coreStr withName:objtemp];
                
            }
            else if([obj[objtemp] isKindOfClass:[NSDate class]]){//如果字典里面是NSDate
                
                if(NSDATE==NO){
                    [self myNSDate:objtemp ToNSMutableString:str];
                    [CreatCoreData addDateCoreDataToNSMutableString:coreStr withName:objtemp];
                }
                else{
                    [self myNSString:[self specialNSString:objtemp] ToNSMutableString:str];
                    [CreatCoreData addStringCoreDataToNSMutableString:coreStr withName:[self specialNSString:objtemp]];
                    [stringArr addObject:[self specialNSString:objtemp]];
                }
                
            }
        }
    }
    else if([obj isKindOfClass:[NSArray class]]){//如果obj对象是数组
        primeArr++;
        NSMutableDictionary *dataModelType=[NSMutableDictionary dictionary];
        for (id objtemp in obj) {
            if([objtemp isKindOfClass:[NSDictionary class]]){
                for (NSString *tempSubStr in objtemp) {
                    if(dataModelType[tempSubStr]==nil){
                        [dataModelType setValue:objtemp[tempSubStr] forKey:tempSubStr];
                    }
                }
            }
            else if([objtemp isKindOfClass:[NSMutableArray class]]){
                NSString *tempFileName=context ;
                if([tempFileName isEqual:@""]&&primeArr==1)
                    tempFileName=modelName;
                [self creatProperty:objtemp fileName:tempFileName WithContext:context savePath:savePath withNSNULL:NSNULL withNSDATE:NSDATE withNSNUMBER:NSNUMBER withGiveData:category withModelName:modelName withFatherClass:@"NSArray" needEcoding:ecoding];
                break;//这种情况没有见过
            }
        }
        NSString *tempFileName=context ;
        if([tempFileName isEqual:@""]&&primeArr==1)
            tempFileName=modelName;
        [self creatProperty:dataModelType fileName:tempFileName WithContext:context savePath:savePath withNSNULL:NSNULL withNSDATE:NSDATE withNSNUMBER:NSNUMBER withGiveData:category withModelName:modelName withFatherClass:@"NSArray" needEcoding:ecoding];
    }
   
    NSString *path=savePath;
    
    [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    [CreatCoreData addReEntityCoreDataToNSMutableString:coreStr];
    
    NSString *corePath=[savePath stringByAppendingString:@"CoreData/"];
    BOOL yes=YES;
    if([[NSFileManager defaultManager]fileExistsAtPath:corePath isDirectory:&yes]==NO){
        [[NSFileManager defaultManager]createDirectoryAtPath:corePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //coreData的相关操作
    NSString *OperationPath=[corePath stringByAppendingString:@"coreData的相关操作函数.m"];
    corePath=[corePath stringByAppendingString:@"coreData表自动生成"];
//    NSLog(@"fileName=%@,modelName=%@",fileName,modelName);
    if(coreStr.length>0){
        
        [coreDataText appendString:coreStr];
        
        if([fileName isEqualToString:modelName]&&primeArr<=1){
            
            //保存coreData的相关操作函数
            [self creatCoreOperationWithSavaPath:OperationPath];
            
            NSArray *newTransformable=[CreatCoreData GetTransformable:coreDataText];
            //        将尾数据导入进去
            [CreatCoreData addEntitysCoreDataToNSMutableString:coreDataText];
            for (NSString *strArrName in newTransformable) {
                if(strArrName.length>0)
                    [CreatCoreData addElementCoreDataToNSMutableString:coreDataText withName:strArrName];
            }
            /*
//            for (NSString *strArrName in arrName) {
//                if(strArrName.length>0)
//                    [CreatCoreData addElementCoreDataToNSMutableString:coreDataText withName:strArrName];
//            }
//            for (NSString *strDicName in dicName) {
//                if(strArrName.length>0)
//                    [CreatCoreData addElementCoreDataToNSMutableString:coreDataText withName:strDicName];
//            }
             */
            [CreatCoreData addReEntitysCoreDataToNSMutableString:coreDataText];
            [CreatCoreData addReModelCoreDataToNSMutableString:coreDataText];
            
            coreDataText=[CreatCoreData RemoveRepeat:coreDataText];
            [coreDataText writeToFile:[corePath stringByAppendingString:@".m"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            primeArr--;
        }
    }
    primeArr--;
    
    //属性生成的相关操作
    path=[path stringByAppendingString:fileName];

    if(str.length>0){//如果没有就不创建文件夹
        
        if(category!=2){
            [staticText_h appendFormat:@"#pragma mark -%@Model\n",fileName];
            [staticText_h appendString:@"@interface "];
            [staticText_h appendFormat:@"%@Model",fileName];
            if(ecoding==YES) [staticText_h appendString:@" : NSObject <NSCoding>\n\n"];
            else [staticText_h appendString:@" : NSObject\n\n"];
            
            [staticText_h appendString:str];
            [staticText_h appendString:@"\n@end\n\n"];
            
            [staticText_m appendFormat:@"#pragma mark -%@Model\n",fileName];
            [staticText_m appendString:@"@implementation "];
            [staticText_m appendFormat:@"%@Model\n\n",fileName];
            //在这里还可以添加其他信息
            if(category==1){
                if(arrName.count>0){
                    for (NSString *name in arrName) {
                        [self initNSMutableArrayWithName:name ToNSMutableString:staticText_m];
                    }
                }
                
                [self setValueForKeyToNSMutableString:staticText_m withNSNUMBER:NSNUMBER];
                [self setValueForUndefinedKeyToNSMutableString:staticText_m withArrNames:arrName withDicNames:dicName withArrSpecialName:arrSpecialName withModelName:modelName withSpecialStringArr:stringArr];
                [self getValueForUndefinedKeyToNSMutableString:staticText_m withSelfModelName:[fileName stringByAppendingString:@"Model"]];
                if(ecoding==YES){
                    
                    [self getEcodeingToNSMutableString:staticText_m withArrInt:intArr withArrFloat:floatArr withArrString:stringArr withArrOrDic:NSArrayOrDictionaryArr];
                    [self getDecodeingToNSMutableString:staticText_m withArrInt:intArr withArrFloat:floatArr withArrString:stringArr withArrOrDic:NSArrayOrDictionaryArr];
                }
                [self getDescriptionToNSMutableString:staticText_m withArrInt:intArr withArrFloat:floatArr withArrString:stringArr withArrOrDic:NSArrayOrDictionaryArr];
            }
            
            [staticText_m appendString:@"@end\n\n"];
            
        }
        else if(category==2){
            //在这里还需要写协议
            [staticText_h appendFormat:@"#pragma mark -%@Model\n",fileName];
            [self addProtocolToNSMutableString:staticText_h withFileName:fileName withModelName:modelName];
            
            [staticText_h appendString:@"@interface "];
            [staticText_h appendFormat:@"%@Model",fileName];
            if(ecoding==YES)[staticText_h appendString:@" : JSONModel <NSCoding>\n\n"];
            else [staticText_h appendString:@" : JSONModel\n\n"];
            [staticText_h appendString:str];
            [staticText_h appendString:@"\n@end\n"];
            
            //还要创建一个.m文件
            [staticText_m appendFormat:@"#pragma mark -%@Model\n",fileName];
            [staticText_m appendString:@"@implementation "];
            [staticText_m appendFormat:@"%@Model\n\n",fileName];
            //在这里还可以添加其他信息
            //1.keyMapper
            [self addKeyMapperToNSMutableString:staticText_m withNSArrayArr:arrName withDicArr:dicName withSpecialStringArr:stringArr];
            [self addPropertyIsOptionalToNSMutableString:staticText_m];
            
            if(ecoding==YES){
                [self getEcodeingToNSMutableString:staticText_m withArrInt:intArr withArrFloat:floatArr withArrString:stringArr withArrOrDic:NSArrayOrDictionaryArr];
                [self getDecodeingToNSMutableString:staticText_m withArrInt:intArr withArrFloat:floatArr withArrString:stringArr withArrOrDic:NSArrayOrDictionaryArr];
            }
            //4.添加打印信息
            [self getDescriptionToNSMutableString:staticText_m withArrInt:intArr withArrFloat:floatArr withArrString:stringArr withArrOrDic:NSArrayOrDictionaryArr];
            
            [staticText_m appendString:@"@end\n"];
        }
        
    }
    
}

//这些函数是为了将所有文件写到一个文件里面
+ (void)addModelHFileWithModelName:(NSString *)modelName withGiveData:(NSInteger)category{
    if(category!=2){
        [staticText_h appendString:@"#import <Foundation/Foundation.h>\n\n"];
    }else{
        [staticText_h appendString:@"#import \"JSONModel.h\"\n\n"];
    }
    [staticText_m setString:@"#import \""];
    [staticText_m appendFormat:@"%@Model.h\"\n\n",modelName];
}
// 特殊字段排除
//比如出现系统关键字:description,id等
+ (NSString *)specialNSString:(NSString *)string{
    if([string isEqualToString:@"id"]||[string isEqualToString:@"description"]){
        return [@"My" stringByAppendingString:string];
    }
    return string;
}

//KVC辅助函数

//初始化可变数组
+ (void)initNSMutableArrayWithName:(NSString *)name ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"- (NSMutableArray *)My"];
    [StrM appendString:name];
    [StrM appendString:@"{\n\tif(!_My"];
    [StrM appendString:name];
    [StrM appendString:@"){\n\t\t_My"];
    [StrM appendString:name];
    [StrM appendString:@"=[[NSMutableArray alloc]init];\n\t}\n\treturn _My"];
    [StrM appendString:name];
    [StrM appendString:@";\n}\n\n"];
}
//初始化可变字典
+ (void)initNSMutableDictionaryWithName:(NSString *)name ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"- (NSMutableDictionary *)My"];
    [StrM appendString:name];
    [StrM appendString:@"{\n\tif(!_My"];
    [StrM appendString:name];
    [StrM appendString:@"){\n\t\t_My"];
    [StrM appendString:name];
    [StrM appendString:@"=[[NSMutableDictionary alloc]init];\n\t}\n\treturn _My"];
    [StrM appendString:name];
    [StrM appendString:@";\n}\n\n"];
}

//添加头文件
+ (void)addModelHFileToNSMutableString:(NSMutableString *)StrM withArrNames:(NSArray *)arrNames withDicNames:(NSArray *)dicNames withModelName:(NSString *)modelName withCategroy:(NSInteger)category{
    
    if(arrNames.count>0){
        for (NSString *name in arrNames) {
            [StrM appendString:@"#import \""];
            if(category==1){
                [StrM appendFormat:@"%@Model.h\"\n",[modelName stringByAppendingString:name]];
            }else if(category==2){
                [StrM appendFormat:@"%@Model.h\"\n",name];
            }
        }
    }
    if(dicNames.count>0){
//        if(category==2){//如果是字典的话,就不需要导入子字典的模型
//            return;
//        }
        for (NSString *name in dicNames) {
            [StrM appendString:@"#import \""];
            if(category==1){
                [StrM appendFormat:@"%@Model.h\"\n",[modelName stringByAppendingString:name]];
            }else if(category==2){
                [StrM appendFormat:@"%@Model.h\"\n",name];
            }
        }
    }
    [StrM appendString:@"\n"];
}

//setValueForUndefinedKey
+ (void)setValueForUndefinedKeyToNSMutableString:(NSMutableString *)StrM withArrNames:(NSArray *)arrNames withDicNames:(NSArray *)dicNames withArrSpecialName:(NSArray *)arrSpecialName withModelName:(NSString *)modelName withSpecialStringArr:(NSArray *)specialStringArr{
    [StrM appendString:@"- (void)setValue:(id)value forUndefinedKey:(NSString *)key{\n"];
    
    int count=0;
    if(arrNames.count>0){
        for (NSString *name in arrNames) {
            if(count==0){
                count=1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            [StrM appendString:name];
            [StrM appendString:@"\"]) {\n\t\tfor (NSDictionary *dic in value) {\n\t\t\t"];
            [StrM appendString:modelName];[StrM appendString:name];
            [StrM appendString:@"Model *model = ["];
            [StrM appendString:modelName];[StrM appendString:name];
            [StrM appendString:@"Model new];\n\t\t\t[model setValuesForKeysWithDictionary:dic];\n\t\t\t[self.My"];
            [StrM appendString:name];
            [StrM appendString:@" addObject:model];\n\t\t}\n\t}\n"];
        }
    }
    
    if(arrSpecialName.count>0){
        for (NSString *name in arrSpecialName) {
            if(count==0){
                count=1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            [StrM appendString:name];
            [StrM appendString:@"\"]) {\n\t\tfor (id obj in value) {\n\t\t\t"];
            [StrM appendString:@"[self.My"];
            [StrM appendString:name];
            [StrM appendString:@" addObject:obj];\n\t\t}\n\t}\n"];
        }
    }
    
    if(dicNames.count>0){
        for (NSString *name in dicNames) {
            if(count==0){
                count=1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            
            [StrM appendString:name];
            [StrM appendString:@"\"]) {\n\t\t"];
            [StrM appendString:modelName];[StrM appendString:name];
            [StrM appendString:@"Model *model = ["];
            [StrM appendString:modelName];[StrM appendString:name];
            [StrM appendString:@"Model new];\n\t\t[model setValuesForKeysWithDictionary:value];\n\t\t"];
            [StrM appendString:@"self.My"];
            [StrM appendString:name];
            [StrM appendString:@" = model"];
            [StrM appendString:@";\n\t}\n"];
        }
    }
    
    if(specialStringArr.count>0){
        for (NSString *name in specialStringArr) {
            if([name hasPrefix:@"My"]==NO)
                continue;
            if(count==0){
                count=1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            
            [StrM appendString:[name substringFromIndex:2]];
            [StrM appendString:@"\"]) {\n\t\t"];
            [StrM appendString:@"[self setValue:value forKey:@\""];
            [StrM appendString:name];
            [StrM appendString:@"\"];\n\t}\n"];
        }
    }
    [StrM appendString:@"}\n\n"];
}

//setValueForKey
+ (void)setValueForKeyToNSMutableString:(NSMutableString *)StrM withNSNUMBER:(BOOL)NSNUMBER{
    [StrM appendString:@"- (void)setValue:(id)value forKey:(NSString *)key{\n"];
    
    if(NSNUMBER==YES){
        [StrM appendString:@"\tif ([value isKindOfClass:[NSNumber class]]) {\n"];
        [StrM appendString:@"\t\t[self setValue:[NSString stringWithFormat:@\"%@\",value] forKey:key];\n\t}else{\n"];
        [StrM appendString:@"\t\t[super setValue:value forKey:key];\n\t}\n"];
    }
    
    [StrM appendString:@"}\n\n"];
}

//getValueForUndefinedKey
+ (void)getValueForUndefinedKeyToNSMutableString:(NSMutableString *)StrM withSelfModelName:(NSString *)selfModelName{
    [StrM appendString:@"-(id)valueForUndefinedKey:(NSString *)key{\n\t"];
    [StrM appendString:@"NSLog(@\"error: "];
    [StrM appendString:selfModelName];
    [StrM appendString:@"数据模型中:未找到key = %@\",key);\n\t"];
    [StrM appendString:@"return nil;\n"];
    [StrM appendString:@"}\n\n"];
}

//Description
+ (void)getDescriptionToNSMutableString:(NSMutableString *)StrM withArrInt:(NSArray *)arrInt withArrFloat:(NSArray *)arrFloat withArrString:(NSArray *)arrString withArrOrDic:(NSArray *)arrOrDic{
    [StrM appendString:@"- (NSString *)description{\n\t"];
    [StrM appendString:@"return [NSString stringWithFormat:@\""];
    NSMutableArray *arrPropert=[NSMutableArray new];
    NSInteger count=arrInt.count+arrFloat.count+arrString.count+arrOrDic.count;
    if(arrInt.count>0){
        for (NSString *tempStr in arrInt) {
            [StrM appendString:tempStr];
            if(count!=1){[StrM appendString:@"=%d,"];}
            else {[StrM appendString:@"=%d"];}
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if(arrFloat.count>0){
        for (NSString *tempStr in arrFloat) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%f,"];
            else [StrM appendString:@"=%f"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if(arrString.count>0){
        for (NSString *tempStr in arrString) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if(arrOrDic.count>0){
        for (NSString *tempStr in arrOrDic) {
            if([tempStr hasPrefix:@"NSArray"]){
                [StrM appendString:@"My"];
                [StrM appendString:[tempStr substringFromIndex:7]];
            }else{
                [StrM appendString:@"My"];
                [StrM appendString:[tempStr substringFromIndex:12]];
            }
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            if([tempStr hasPrefix:@"NSArray"]){
                [arrPropert addObject:[@"_" stringByAppendingString:[@"My"stringByAppendingString:[tempStr substringFromIndex:7]]]];
            }else{
                [arrPropert addObject:[@"_My" stringByAppendingString:[tempStr substringFromIndex:12]]];
            }
            
            count--;
        }
    }
    count=arrPropert.count;
    if(count>0)
        [StrM appendString:@"\","];
    else [StrM appendString:@"\""];
    for (NSString *tempStr in arrPropert) {
        [StrM appendString:tempStr];
        if(count!=1)
            [StrM appendString:@","];
        count--;
    }
    [StrM appendString:@"];\n"];
    [StrM appendString:@"}\n\n"];
}

//归档相关
+ (void)getEcodeingToNSMutableString:(NSMutableString *)StrM withArrInt:(NSArray *)arrInt withArrFloat:(NSArray *)arrFloat withArrString:(NSArray *)arrString withArrOrDic:(NSArray *)arrOrDic{
    [StrM appendString:@"- (void)encodeWithCoder:(NSCoder *)aCoder{\n"];
    
    if(arrInt.count>0){
        for (NSString *tempStr in arrInt) {
            [StrM appendFormat:@"\t[aCoder encodeInt32:self.%@ forKey:@\"%@\"];\n",tempStr,tempStr];
        }
    }
    if(arrFloat.count>0){
        for (NSString *tempStr in arrFloat) {
            [StrM appendFormat:@"\t[aCoder encodeFloat:self.%@ forKey:@\"%@\"];\n",tempStr,tempStr];
        }
    }
    if(arrString.count>0){
        for (NSString *tempStr in arrString) {
            [StrM appendFormat:@"\t[aCoder encodeObject:self.%@ forKey:@\"%@\"];\n",tempStr,tempStr];
        }
    }
    if(arrOrDic.count>0){
        for (NSString *tempStr in arrOrDic) {
            if([tempStr hasPrefix:@"NSDictionary"]){
                [StrM appendFormat:@"\t[aCoder encodeObject:self.My%@ forKey:@\"My%@\"];\n",[tempStr substringFromIndex:12],[tempStr substringFromIndex:12]];
            }else{
                [StrM appendFormat:@"\t[aCoder encodeObject:self.%@ forKey:@\"%@\"];\n",[@"My" stringByAppendingString:[tempStr substringFromIndex:7]],[@"My" stringByAppendingString:[tempStr substringFromIndex:7]]];
            }
        }
    }
    [StrM appendString:@"}\n\n"];
}
+ (void)getDecodeingToNSMutableString:(NSMutableString *)StrM withArrInt:(NSArray *)arrInt withArrFloat:(NSArray *)arrFloat withArrString:(NSArray *)arrString withArrOrDic:(NSArray *)arrOrDic{
    [StrM appendString:@"- (id)initWithCoder:(NSCoder *)aDecoder{\n\tif (self = [super init]) {\n\t"];
    
    if(arrInt.count>0){
        for (NSString *tempStr in arrInt) {
            [StrM appendFormat:@"\tself.%@ = [aDecoder decodeInt32ForKey:@\"%@\"];\n\t",tempStr,tempStr];
        }
    }
    if(arrFloat.count>0){
        for (NSString *tempStr in arrFloat) {
            [StrM appendFormat:@"\tself.%@ = [aDecoder decodeFloatForKey:@\"%@\"];\n\t",tempStr,tempStr];
        }
    }
    if(arrString.count>0){
        for (NSString *tempStr in arrString) {
            [StrM appendFormat:@"\tself.%@ = [aDecoder decodeObjectForKey:@\"%@\"];\n\t",tempStr,tempStr];
        }
    }
    if(arrOrDic.count>0){
        for (NSString *tempStr in arrOrDic) {
            if([tempStr hasPrefix:@"NSDictionary"]){
                [StrM appendFormat:@"\tself.My%@ = [aDecoder decodeObjectForKey:@\"My%@\"];\n\t",[tempStr substringFromIndex:12],[tempStr substringFromIndex:12]];
            }else{
                [StrM appendFormat:@"\tself.%@ = [aDecoder decodeObjectForKey:@\"%@\"];\n\t",[@"My" stringByAppendingString:[tempStr substringFromIndex:7]],[@"My" stringByAppendingString:[tempStr substringFromIndex:7]]];
            }
        }
    }
    [StrM appendString:@"}\n\treturn self;\n}\n\n"];
}

//JSONModel辅助函数
+ (void)addProtocolToNSMutableString:(NSMutableString *)StrM withFileName:(NSString *)fileName withModelName:(NSString *)modelName{
    if([modelName isEqualToString:fileName]==NO){
        [StrM appendString:@"@protocol "];
        [StrM appendString:fileName];
        [StrM appendString:@"Model <NSObject>\n\n"];
        [StrM appendString:@"@end\n\n"];
    }
}
//1.keyMapper
+ (void)addKeyMapperToNSMutableString:(NSMutableString *)StrM withNSArrayArr:(NSArray *)NSArrayArr withDicArr:(NSArray *)dicArr withSpecialStringArr:(NSArray *)specialStringArr{
    [StrM appendString:@"+(JSONKeyMapper *)keyMapper{\n\t"];
    [StrM appendString:@"return [[JSONKeyMapper alloc] initWithDictionary:@{"];
    NSInteger count=NSArrayArr.count+dicArr.count+[self hasMyString:specialStringArr];
    for (NSString *str in NSArrayArr) {
        [StrM appendString:@"@\""];[StrM appendString:str];[StrM appendString:@"\":@\""];
        [StrM appendString:@"My"];[StrM appendString:str];[StrM appendString:@"\""];
        if(count!=1)
           [StrM appendString:@","];
        count--;
    }
    for (NSString *str in dicArr) {
        [StrM appendString:@"@\""];[StrM appendString:str];[StrM appendString:@"\":@\""];
        [StrM appendString:@"My"];[StrM appendString:str];[StrM appendString:@"\""];
        if(count!=1)
            [StrM appendString:@","];
        count--;
    }
    for (NSString *str in specialStringArr) {
        if([str hasPrefix:@"My"]==NO)
            continue;
        [StrM appendString:@"@\""];[StrM appendString:[str substringFromIndex:2]];[StrM appendString:@"\":@\""];
        [StrM appendString:str];[StrM appendString:@"\""];
        if(count!=1)
            [StrM appendString:@","];
        count--;
    }
     [StrM appendString:@"}];\n}\n\n"];
}

+ (NSInteger)hasMyString:(NSArray *)stringArr{
    NSInteger count=0;
    for (NSString *str in stringArr) {
        if([str hasPrefix:@"My"])
            count++;
    }
    return count;
}
//2.propertyIsIgnored
+ (void)addPropertyIsIgnoredToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"+ (BOOL)propertyIsIgnored:(NSString *)propertyName{\n\t"];
    [StrM appendString:@"return YES;\n}\n\n"];
}
//3.propertyIsOptional
+ (void)addPropertyIsOptionalToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"+(BOOL)propertyIsOptional:(NSString *)propertyName{\n\t"];
    [StrM appendString:@"return YES;\n}\n\n"];
}

+ (void)creatCoreOperationWithSavaPath:(NSString *)savePath{
    NSMutableString *CoreOperation=[NSMutableString string];
    [CreatCoreData addHeadFileToNSMutableString:CoreOperation];
    [CreatCoreData addNSManagedObjectContextToNSMutableString:CoreOperation];
    [CreatCoreData addSearchFromDatabaseToNSMutableString:CoreOperation];
    [CreatCoreData insertDataToNSMutableString:CoreOperation];
    [CreatCoreData updataDataToNSMutableString:CoreOperation];
    [CreatCoreData deleteDataToNSMutableString:CoreOperation];
    [CreatCoreData searchDataToNSMutableString:CoreOperation];
    [CoreOperation writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
