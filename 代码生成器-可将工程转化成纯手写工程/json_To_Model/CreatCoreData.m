#import "CreatCoreData.h"

@implementation CreatCoreData


+ (NSMutableString *)RemoveRepeat:(NSString *)strM{
    NSMutableString *StrM=[NSMutableString string];
    NSMutableArray *Target=[NSMutableArray array];
    NSMutableArray *arrMs=[NSMutableArray array];
    NSArray *arrs=[strM componentsSeparatedByString:@"\n"];
    for (NSString *str in arrs) {
        if(str.length>0)
           [arrMs addObject:str];
    }
//    NSLog(@"%@",arrMs);
    NSInteger count=arrMs.count;
    NSInteger i;
    for (i=0; i<count; i++) {
        if(i+1<count&&[arrMs[i] rangeOfString:@"<entity"].location!=NSNotFound&&[arrMs[i+1] rangeOfString:@"</entity"].location!=NSNotFound){
            i++;
        }else{
            if([arrMs[i] rangeOfString:@"<entity"].location!=NSNotFound||[arrMs[i] rangeOfString:@"</entity"].location!=NSNotFound||[arrMs[i] rangeOfString:@"<elements"].location!=NSNotFound||[arrMs[i] rangeOfString:@"</elements>"].location!=NSNotFound)
                [Target addObject:[@"\t\t" stringByAppendingString:arrMs[i]]];
            
            else if([arrMs[i] rangeOfString:@"<attribute"].location!=NSNotFound||[arrMs[i] rangeOfString:@"<element"].location!=NSNotFound)
                [Target addObject:[@"\t\t\t" stringByAppendingString:arrMs[i]]];
            else [Target addObject:arrMs[i]];
        }
    }
    
    StrM=[NSMutableString stringWithString:[Target componentsJoinedByString:@"\n"]];
    return StrM;
}

+ (NSArray *)GetTransformable:(NSString *)strM{
    NSMutableArray *Target=[NSMutableArray array];
    NSMutableArray *arrMs=[NSMutableArray array];
    NSArray *arrs=[strM componentsSeparatedByString:@"\n"];
    for (NSString *str in arrs) {
        if(str.length>0)
            [arrMs addObject:str];
    }
    NSInteger count=arrMs.count;
    NSInteger i;
    for (i=0; i<count; i++) {
        if(i+1<count&&[arrMs[i] rangeOfString:@"<entity"].location!=NSNotFound&&[arrMs[i+1] rangeOfString:@"</entity"].location!=NSNotFound){
            i++;
        }else{//<entity name="directors" syncable="YES">
            if([arrMs[i] rangeOfString:@"<entity"].location!=NSNotFound){
                NSString *subStr=[arrMs[i] substringFromIndex:14];
                subStr=[subStr substringToIndex:[subStr rangeOfString:@"\""].location];
                //NSLog(@"subStr=%@ arrMs[i]=%@",subStr,arrMs[i]);
                [Target addObject:[subStr copy]];
            }
        }
    }
    return Target;
}

//1.生成Integer 32
+ (void)addIntegerCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [self addAttributeCoreDataToNSMutableString:StrM];
    [self addNameCoreDataToNSMutableString:StrM withName:name];
    [self addOptionalCoreDataToNSMutableString:StrM];
    [self addAttributeTypeCoreDataToNSMutableString:StrM withAttributeType:@"Integer 32"];
    [self addDefaultValueStringCoreDataToNSMutableString:StrM withIntOrFloat:YES];
    [self addSyncableCoreDataToNSMutableString:StrM];
//    <attribute name="attribute" optional="YES" attributeType="Integer 32" defaultValueString="0" syncable="YES"/>
}

//2.生成Binary
+ (void)addBinaryCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [self addAttributeCoreDataToNSMutableString:StrM];
    [self addNameCoreDataToNSMutableString:StrM withName:name];
    [self addOptionalCoreDataToNSMutableString:StrM];
    [self addAttributeTypeCoreDataToNSMutableString:StrM withAttributeType:@"Binary"];
    [self addSyncableCoreDataToNSMutableString:StrM];
//    <attribute name="attribute9" optional="YES" attributeType="Binary" syncable="YES"/>
}

//3.生成Date
+ (void)addDateCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [self addAttributeCoreDataToNSMutableString:StrM];
    [self addNameCoreDataToNSMutableString:StrM withName:name];
    [self addOptionalCoreDataToNSMutableString:StrM];
    [self addAttributeTypeCoreDataToNSMutableString:StrM withAttributeType:@"Date"];
    [self addSyncableCoreDataToNSMutableString:StrM];
//    <attribute name="attribute8" optional="YES" attributeType="Date" syncable="YES"/>
}

//4.生成Float
+ (void)addFloatCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [self addAttributeCoreDataToNSMutableString:StrM];
    [self addNameCoreDataToNSMutableString:StrM withName:name];
    [self addOptionalCoreDataToNSMutableString:StrM];
    [self addAttributeTypeCoreDataToNSMutableString:StrM withAttributeType:@"Float"];
    [self addDefaultValueStringCoreDataToNSMutableString:StrM withIntOrFloat:NO];
    [self addSyncableCoreDataToNSMutableString:StrM];
//    <attribute name="attribute5" optional="YES" attributeType="Float" defaultValueString="0.0" syncable="YES"/>
}

//5.生成String
+ (void)addStringCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [self addAttributeCoreDataToNSMutableString:StrM];
    [self addNameCoreDataToNSMutableString:StrM withName:name];
    [self addOptionalCoreDataToNSMutableString:StrM];
    [self addAttributeTypeCoreDataToNSMutableString:StrM withAttributeType:@"String"];
    [self addSyncableCoreDataToNSMutableString:StrM];
//    <attribute name="attribute6" optional="YES" attributeType="String" syncable="YES"/>
}

//6.生成Transformable
+ (void)addTransformableCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [self addAttributeCoreDataToNSMutableString:StrM];
    [self addNameCoreDataToNSMutableString:StrM withName:name];
    [self addOptionalCoreDataToNSMutableString:StrM];
    [self addAttributeTypeCoreDataToNSMutableString:StrM withAttributeType:@"Transformable"];
    [self addSyncableCoreDataToNSMutableString:StrM];
//    <attribute name="attribute10" optional="YES" attributeType="Transformable" syncable="YES"/>
}

//7.生成Entity<entity name="Entity" syncable="YES">
+ (void)addEntityCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [StrM appendString:@"<entity name=\""];
    [StrM appendString:name];
    [StrM appendString:@"\" syncable=\"YES\">\n"];
}
//8.生成</entity>
+ (void)addReEntityCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"</entity>\n"];
}
//9.生成<elements>
+ (void)addEntitysCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"<elements>\n"];
}
//9.1生成<element>
+ (void)addElementCoreDataToNSMutableString:(NSMutableString *)StrM  withName:(NSString *)name{
    [StrM appendString:@"<element name=\""];
    [StrM appendString:name];
    [StrM appendString:@"\" positionX=\"0\" positionY=\"0\" width=\"128\" height=\"108\"/>\n"];
}
//10.生成</elements>
+ (void)addReEntitysCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"</elements>\n"];
}
//11.生成</model>
+ (void)addReModelCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"</model>"];
}



//1.生成Attribute
+ (void)addAttributeCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"<attribute "];
}

//2.生成Name
+ (void)addNameCoreDataToNSMutableString:(NSMutableString *)StrM withName:(NSString *)name{
     [StrM appendString:@"name=\""];
    [StrM appendString:name];
    [StrM appendString:@"\""];
}

//3.生成Optional
+ (void)addOptionalCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@" optional=\"YES\""];
}

//4.生成AttributeType
+ (void)addAttributeTypeCoreDataToNSMutableString:(NSMutableString *)StrM withAttributeType:(NSString *)attributeType{
    [StrM appendString:@" attributeType=\""];
    [StrM appendString:attributeType];
    [StrM appendString:@"\""];
}

//5.生成DefaultValue
+ (void)addDefaultValueStringCoreDataToNSMutableString:(NSMutableString *)StrM withIntOrFloat:(BOOL)Int{
    [StrM appendString:@" defaultValueString=\""];
    if(Int)
        [StrM appendString:@"0"];
    else [StrM appendString:@"0.0"];
    [StrM appendString:@"\""];
}

//6.生成Syncable
+ (void)addSyncableCoreDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@" syncable=\"YES\"/>\n"];
}

+ (void)addXMLinfoToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"];
    [StrM appendString:@"<model <#name=\"Test1.xcdatamodel\" #>userDefinedModelVersionIdentifier=\"\" "];
    [StrM appendString:@"type=\"com.apple.IDECoreDataModeler.DataModel\" documentVersion=\"1.0\" "];
    [StrM appendString:@"lastSavedToolsVersion=\"<#最后一次保存的工具版本#>\" systemVersion=\"<#系统版本#>\" minimumToolsVersion=\"Automatic\" "];
    [StrM appendString:@"macOSVersion=\"Automatic\" iOSVersion=\"Automatic\">\n\n"];
}



//导入辅助函数

//1.导入NSManagedObjectContext
+ (void)addNSManagedObjectContextToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"//添加属性\n"];
    [StrM appendString:@"@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;\n\n"];
    [StrM appendString:@"//懒加载managedObjectContext\n"];
    [StrM appendString:@"-(NSManagedObjectContext *)managedObjectContext{\n\tif (!_managedObjectContext) {\n\t\tAppDelegate *del = [UIApplication sharedApplication].delegate;\n\t\t_managedObjectContext = del.managedObjectContext;\n\treturn _managedObjectContext;\n}\n\n"];
}
//2.1导入AppDelegate.h
+ (void)addHeadFileToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"//导入需要的AppDelegate.h头文件\n"];
    [StrM appendString:@"#import \"AppDelegate.h\"\n\n"];
}
//3.1插入数据
+ (void)insertDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"\n\n//插入数据\n"];
    [StrM appendString:@"- (void)insertData{\n\t"];
    [StrM appendString:@"<#Person#>"];
    [StrM appendString:@"*myModel = [NSEntityDescription insertNewObjectForEntityForName:@\""];
    [StrM appendString:@"<#Person#>"];
    [StrM appendString:@"\" inManagedObjectContext:self.managedObjectContext];\n\n\t"];
    
    //KVC赋值
    [StrM appendString:@"//KVC赋值\n\t"];
    [StrM appendString:@"[model setValuesForKeysWithDictionary:<#dic#>];\n\n\t"];
    
    //简单赋值
    [StrM appendString:@"//普通属性赋值\n\t"];
    [StrM appendString:@"model.属性= 某值;\n\n\t"];
    
    [StrM appendString:@"//保存\n\t"];
    [StrM appendString:@"[self.managedObjectContext save:nil];\n}\n\n"];
}
//3.2修改数据
+ (void)updataDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"\n\n//修改数据\n"];
    [StrM appendString:@"- (void)updataData{\n\t"];
    
    [StrM appendString:@"NSArray *resultArr = [self searchFromDatabase];\n\t"];
    [StrM appendString:@"<#Person#>"];
    [StrM appendString:@" *model=[resultArr objectAtIndex:<#%ld#>]\n\n\t"];
    
    [StrM appendString:@"//KVC赋值\n\t"];
    [StrM appendString:@"[model setValuesForKeysWithDictionary:<#dic#>];\n\n\t"];
    
    [StrM appendString:@"//普通属性赋值\n\t"];
    [StrM appendString:@"model.属性= 某值;\n\n\t"];
    
    [StrM appendString:@"//保存\n\t"];
    [StrM appendString:@"[self.managedObjectContext save:nil];\n}\n\n"];
    
}
//3.3删除数据
+ (void)deleteDataToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"\n\n//删除数据\n"];
    [StrM appendString:@"- (void)deleteData{\n\t"];
    
    [StrM appendString:@"NSArray *resultArr = [self searchFromDatabase];\n\n\t"];
    [StrM appendString:@"//删除某一个数据\n\t"];
    [StrM appendString:@"<#Person#> "];
    [StrM appendString:@"*model=[resultArr objectAtIndex:<#%ld#>]\n\t"];
    [StrM appendString:@"[self.managedObjectContext deleteObject:per];\n\n\t"];
    
    [StrM appendString:@"//删除全部这个模型的数据\n\t"];
    [StrM appendString:@"for ("];
    [StrM appendString:@"<#Person#>"];
    [StrM appendString:@"*model in [self searchFromDatabase]) {\n\t\t"];
    [StrM appendString:@"[self.managedObjectContext deleteObject:model];\n\t}\n\n\t"];
    
    [StrM appendString:@"//保存\n\t"];
    [StrM appendString:@"[self.managedObjectContext save:nil];\n}\n\n"];
    
}
//3.4查询数据
+ (void)searchDataToNSMutableString:(NSMutableString *)StrM{
    
    [StrM appendString:@"\n\n//查询数据\n"];
    
    [StrM appendString:@"- (void)searchData{\n\t"];
    
    [StrM appendString:@"for ("];
    [StrM appendString:@"<#Person#>"];
    [StrM appendString:@"*model in [self searchFromDatabase]) {\n\t\t"];
    [StrM appendString:@"//操作该模型对象;\n\t}\n\n\t"];
    
    [StrM appendString:@"//多表联系(示例)\n\t"];
    [StrM appendString:@"//NSFetchRequest *request = [NSFetchRequest new];\n\t"];
    
    [StrM appendString:@"//request.entity = [NSEntityDescription entityForName:@\"<#ModelName#>\" inManagedObjectContext:self.managedObjectContext];\n\t"];
    [StrM appendString:@"//NSArray *resultArr = [self.managedObjectContext executeFetchRequest:request error:nil];\n\t"];
    [StrM appendString:@"//遍历查询结果\n\t"];
    [StrM appendString:@"//for (School *school in resultArr) {\n\t\t"];
    [StrM appendString:@"//for (Student *stu in school.studentShip) {\n\t\t\t"];
    [StrM appendString:@"//操作该模型对象;\n\t\t//}\n\t"];
    [StrM appendString:@"//}\n\n"];
    
    [StrM appendString:@"}\n\n"];
}

//4添加查询数据库
+ (void)addSearchFromDatabaseToNSMutableString:(NSMutableString *)StrM{
    //查询数据库
    [StrM appendString:@"- (NSArray *)searchFromDatabase{\n\t"];
    [StrM appendString:@"NSFetchRequest *request = [NSFetchRequest new];\n\t"];
    
    [StrM appendString:@"//设置查询的是哪一张表\n\t"];
    [StrM appendString:@"request.entity = [NSEntityDescription entityForName:@\"\" inManagedObjectContext:self.managedObjectContext];\n\n\t"];
    
    [StrM appendString:@"//限制查询数据数目\n\t"];
    [StrM appendString:@"if (flag) {\n\t\t"];
    [StrM appendString:@"etchRequest.fetchLimit = <#%ld#>;\n\t}\n\n\t"];
    
    [StrM appendString:@"//条件查询\n\t"];
    [StrM appendString:@"//NSPredicate *predicate = [NSPredicate predicateWithFormat:@\"<#属性名 = %@#>\",<#@\"属性值\"#>];\n\t"];
    [StrM appendString:@"//设置为查询条件\n\t"];
    [StrM appendString:@"//request.predicate = predicate;\n\n\t"];
    [StrM appendString:@"//设置排序//YES代表升序,NO代表降序\n\t"];
    [StrM appendString:@"NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@\"<#某一个属性(一般为整形数据)#>\" ascending:NO];\n\t"];
    [StrM appendString:@"//设置为排序条件\n\t"];
    [StrM appendString:@"request.sortDescriptors = @[sort];\n\t"];
    [StrM appendString:@"return  [self.managedObjectContext executeFetchRequest:request error:nil];\n}\n\n"];
}


@end
