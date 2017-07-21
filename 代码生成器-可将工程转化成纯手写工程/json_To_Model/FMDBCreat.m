#import "FMDBCreat.h"
#import "RunTime.h"
@interface FMDBCreat ()
//可能会出现的问题:NSdata无法打开
@end
@implementation FMDBCreat

#pragma mark -----------辅助函数

//获取某一行属性声明中的属性名字和属性类型
+ (NSArray *)getNameAndAtributesFormLineText:(NSString *)lineText{
    if([lineText rangeOfString:@")"].location!=NSNotFound){
        NSString *myText=[lineText substringFromIndex:[lineText rangeOfString:@")"].location+1];
        myText=[FMDBCreat removeSpaceAndSemicolon:myText];
        NSString *atribute=[myText substringToIndex:[myText rangeOfString:@" "].location];
        myText=[myText substringFromIndex:[myText rangeOfString:@" "].location+1];
        NSString *name=[FMDBCreat removeSpaceAndSemicolon:myText];
        return @[name,atribute];
    }
    return nil;
}
//去除头尾部的分号和空格和*字符
+ (NSString *)removeSpaceAndSemicolon:(NSString *)lineText{
    if([lineText hasPrefix:@" "]){
        lineText=[lineText substringFromIndex:1];
        lineText=[FMDBCreat removeSpaceAndSemicolon:lineText];
    }
    if([lineText hasPrefix:@"*"]){
        lineText=[lineText substringFromIndex:1];
        lineText=[FMDBCreat removeSpaceAndSemicolon:lineText];
    }
    if([lineText rangeOfString:@";"].location!=NSNotFound){
        lineText=[lineText substringToIndex:[lineText rangeOfString:@";"].location];
        lineText=[FMDBCreat removeSpaceAndSemicolon:lineText];
    }
    return lineText;
}
//根据个数类获取换行的个数字符串
+ (NSString *)getTabSpaceWithTCount:(NSInteger)count{
    return @"";
//    NSMutableString *tabString=[NSMutableString string];
//    for(NSInteger i=0;i<count;i++){
//        [tabString appendString:@"\t"];
//    }
//    return tabString;
}

#pragma mark -----------主体函数
//获取某个路径下所有的.h文件
+ (NSArray *)getAllFileNameWithPath:(NSString *)path{
    NSMutableArray *myArrM=[NSMutableArray array];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    NSArray *arrPath=[fm subpathsAtPath:path];
    
    for (NSString *tempPath in arrPath) {
        if([tempPath hasSuffix:@".h"]){
            [myArrM addObject:tempPath];
        }
    }
    return myArrM;
}
//获取所有的字段名和字段类型
+ (NSDictionary *)getAllNameAndAtributesFromFilePath:(NSString *)filePath{
    NSMutableDictionary *myDicM=[NSMutableDictionary dictionary];
    NSString *text=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *textArr=[text componentsSeparatedByString:@"\n"];
    for (NSString *lineText in textArr) {
        if([lineText hasPrefix:@"@property"]){
            NSArray *tempNameAndAtribute=[FMDBCreat getNameAndAtributesFormLineText:lineText];
            [myDicM setValue:tempNameAndAtribute[1] forKey:tempNameAndAtribute[0]];
        }
    }
    return myDicM;
}
//获取类名
+ (NSString *)getClassNameFromFilePath:(NSString *)filePath{
    filePath=[filePath stringByDeletingPathExtension];
    if([filePath rangeOfString:@"/" options:NSBackwardsSearch].location!=NSNotFound)
        filePath=[filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location+1];
    return filePath;
}
//生成创建表格的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatTableNameFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM withInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendString:@"-(FMDatabase *)database{\n\tif (!_database) {\n\t\t_database = [[FMDatabase alloc] initWithPath:[NSHomeDirectory() stringByAppendingString:@\"/Documents/dataBase.rdb\"]];\n\t\tif (![_database open]) {\n\t\t\tNSLog(@\"数据库创建失败\");\n\t\t}\n\t\t"];
    
    [text appendString:[FMDBCreat getTabSpaceWithTCount:tCount]];
    [text appendFormat:@"if (![_database executeUpdate:@\"create table if not exists %@ (id integer primary key autoincrement ,",className];
    NSInteger modelCount=0;
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        if([nameAndAtributesDicM[property] isEqualToString:@"NSString"]==NO)modelCount++;
    }
    NSInteger count=nameAndAtributesDicM.count-modelCount;
    [text appendString:[FMDBCreat getTabSpaceWithTCount:tCount]];
    for (NSString *property in nameAndAtributesDicM) {
        if([nameAndAtributesDicM[property] isEqualToString:@"NSString"]){
            [text appendString:property];
//        else if([nameAndAtributesDicM[property] isEqualToString:@"NSMutableDictionary"]||[[FMDBCreat getAtributes:nameAndAtributesDicM[property]] isEqualToString:@"NSDictionary"]){
//            [text appendString: @" Dictionary"];[text appendString:property];
//        }
//        else if([nameAndAtributesDicM[property] isEqualToString:@"NSMutableArray"]||[[FMDBCreat getAtributes:nameAndAtributesDicM[property]] isEqualToString:@"NSArray"]){
//            [text appendString: @" Array"];[text appendString:property];
//        }
            [text appendString: @" text"];
            if(count!=1)[text appendString:@","];
            count--;
        }
    }
    [text appendFormat:@")\"]) {%@\n\t\t\tNSLog(@\"创建表失败\");%@\n\t\t}%@\n\t",[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount]];
    [text appendString:@"}\n\treturn _database;\n}\n"];
    return text;
}
//生成读取数据的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatReadDataFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM  withInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"-(void)loadDataFromDatabase{\n\tFMResultSet *set = [self.database executeQuery:@\"select * from %@\"];%@\n\t\twhile ([set next]) {%@\n\t\t\t%@ *model=[[%@ alloc]init];%@\n\t\t",className,[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount],className,className,[FMDBCreat getTabSpaceWithTCount:tCount]];
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        if([nameAndAtributesDicM[property] isEqualToString:@"NSString"]){
            [text appendString:@"\tmodel."];
            [text appendString:property];
            [text appendString:@"=[set stringForColumn:@\""];
            [text appendString:property];
            [text appendFormat:@"\"];%@\n\t\t",[FMDBCreat getTabSpaceWithTCount:tCount]];
        }
    }
    [text appendFormat:@"}\n}\n"];
    return text;
}
//生成插入数据的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatInsertDataFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM withInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"%@ *model=[[%@ alloc]init];\n[model setValuesForKeysWithDictionary:responseObject];\n%@if (![_database executeUpdate:@\"insert into %@ (",className,className,[FMDBCreat getTabSpaceWithTCount:tCount],className];
    
    NSInteger modelCount=0;
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        if([nameAndAtributesDicM[property] isEqualToString:@"NSString"]==NO)modelCount++;
    }
    NSInteger count=nameAndAtributesDicM.count-modelCount;
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        if([nameAndAtributesDicM[property] isEqualToString:@"NSString"]){
            [text appendString:property];
            if(count!=1) [text appendString: @","];
            else [text appendString:@") values ("];
            count--;
        }
    }
    count=nameAndAtributesDicM.count-modelCount;
    for(NSInteger i=count;i>0;i--){
        if(count!=1)[text appendString: @"?,"];
        else [text appendString: @"?)\","];
        count--;
    }
    count=nameAndAtributesDicM.count-modelCount;
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        if([nameAndAtributesDicM[property] isEqualToString:@"NSString"]){
            [text appendString: @"model."];//这里需要一个模型名字
            [text appendString:property];
            if(count!=1) [text appendString: @","];
            else [text appendFormat:@"]) {%@\n\tNSLog(@\"插入失败\");%@\n}%@\n",[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount]];
            count--;
        }
    }
    return text;
}
//生成删除表格中的数据的SQL语句(还带了一个参数:缩进多少个\t)
+ (NSString *)creatDeleteDatawithInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"if (![self.database executeUpdate:@\"delete * from %@\"]) {\n\tNSLog(@\"删除失败\");\n}\n",className];
    return text;
}
+ (void)writeToFileWithFilePath:(NSString *)filePath{
    NSMutableString *myText=[NSMutableString string];
    for (NSString *path in [FMDBCreat getAllFileNameWithPath:filePath]) {
        NSDictionary *dic=[FMDBCreat getAllNameAndAtributesFromFilePath:[filePath stringByAppendingString:path]];
        
        //这些是生成所有的创建表 插入数据 删除数据 读取数据的函数
        [myText appendFormat:@"\n\n\n\n\n\n\n\n#pragma mark -----------模型:  %@  \n\n",[FMDBCreat getClassNameFromFilePath:path]];
        [myText appendFormat:@"//创建表:%@\n",[FMDBCreat getClassNameFromFilePath:path]];
        [myText appendString: [FMDBCreat creatTableNameFromNameAndAtributesDic:dic withInsideValue:2 withClassName:[FMDBCreat getClassNameFromFilePath:path]]];
        [myText appendFormat:@"//插入数据:%@\n",[FMDBCreat getClassNameFromFilePath:path]];
        [myText appendString:[FMDBCreat creatInsertDataFromNameAndAtributesDic:dic withInsideValue:2 withClassName:[FMDBCreat getClassNameFromFilePath:path]]];
        [myText appendFormat:@"//读取数据:%@\n",[FMDBCreat getClassNameFromFilePath:path]];
        [myText appendString:[FMDBCreat creatReadDataFromNameAndAtributesDic:dic withInsideValue:2 withClassName:[FMDBCreat getClassNameFromFilePath:path]]];
        [myText appendFormat:@"//删除数据:%@\n",[FMDBCreat getClassNameFromFilePath:path]];
        [myText appendString:[FMDBCreat creatDeleteDatawithInsideValue:2 withClassName:[FMDBCreat getClassNameFromFilePath:path]]];
    }
    [myText writeToFile:[NSString stringWithFormat:@"%@/FMDB操作语句.m",filePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


/*
 1.假设里面是全字符串
 (将每个模型里面自带一个保存数据的方法)(参数是模型数据)
    将每个数据项直接插入到数据库的表中(不用标识符)
 - (void)insertData:(ZHbanner_listModel *)model{
     if (![_database executeUpdate:@"insert into ZHbanner_listModel (banner_imgurl,p_type,item_id,open) values (?,?,?,?)",appdata.banner_imgurl,appdata.p_type,appdata.item_id,appdata.open]) {
         NSLog(@"插入失败");
     }
 }
 
 (每个模型里有自带一个读取表的方法)
    将表中数据项全都读取出来,带一个读取个数限制和条件查询限制
 
 //不带条件
 -(ZHbanner_listModel *)readDataNoConditions{
	FMResultSet *set = [self.database executeQuery:@"select * from ZHbanner_listModel"];
     ZHbanner_listModel *model=[[ZHbanner_listModel alloc]init];
    NSInteger i=0;
     while ([set next]) {
         if(i++>=self.dataCount)break;
         model.banner_imgurl=[set stringForColumn:@"banner_imgurl"];
         model.p_type=[set stringForColumn:@"p_type"];
         model.item_id=[set stringForColumn:@"item_id"];
         model.open=[set stringForColumn:@"open"];
     }
     return model;
 }

 //带条件查询
 -(ZHbanner_listModel *)readDataHaveConditionsWithFMResultSe:(FMResultSet *)set{
     ZHbanner_listModel *model=[[ZHbanner_listModel alloc]init];
     NSInteger i=0;
     while ([set next]) {
         if(i++>=self.dataCount)
             break;
         model.banner_imgurl=[set stringForColumn:@"banner_imgurl"];
         model.p_type=[set stringForColumn:@"p_type"];
         model.item_id=[set stringForColumn:@"item_id"];
         model.open=[set stringForColumn:@"open"];
     }
     return model;
 }
 
 (每个模型里面都自带一个删除表中数据的方法)
 - (void)deleteData{
     if (![self.database executeUpdate:@"delete * from ZHbanner_listModel"]) {
         NSLog(@"删除失败");
     }
 }
 插入数据:参数:Model(类名)
 */
+ (NSString *)modelCreatInsertDataFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM withInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@" - (void)insertData:(ZHbanner_listModel *)model{\n\t%@if (![_database executeUpdate:@\"insert into %@ (",[FMDBCreat getTabSpaceWithTCount:tCount],className];
    NSInteger count=nameAndAtributesDicM.count;
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        [text appendString:property];
        if(count!=1) [text appendString: @","];
        else [text appendString:@") values ("];
        count--;
    }
    count=nameAndAtributesDicM.count;
    for(NSInteger i=count;i>0;i--){
        if(count!=1)[text appendString: @"?,"];
        else [text appendString: @"?)\","];
        count--;
    }
    count=nameAndAtributesDicM.count;
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        [text appendString: @"appdata."];//这里需要一个模型名字
        [text appendString:property];
        if(count!=1) [text appendString: @","];
        else [text appendFormat:@"]) {%@\n\t\tNSLog(@\"插入失败\");%@\n\t}%@\n}\n",[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount]];
        count--;
    }
    return text;
}
+ (NSString *)modelCreatReadDataNoConditionsFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM  withInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"-(%@ *)readDataNoConditions{\n\tFMResultSet *set = [self.database executeQuery:@\"select * from %@\"];%@\n\t%@ *model=[[%@ alloc]init];\n\tNSInteger i=0;\n\twhile ([set next]) {%@\n\t\tif(i++>=self.dataLimiteCount)break;%@\n\t",className,className,[FMDBCreat getTabSpaceWithTCount:tCount],className,className,[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount]];
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        [text appendString:@"\tmodel."];
        [text appendString:property];
        [text appendString:@"=[set stringForColumn:@\""];
        [text appendString:property];
        [text appendFormat:@"\"];%@\n\t",[FMDBCreat getTabSpaceWithTCount:tCount]];
    }
    [text appendFormat:@"}\n\treturn model;\n}\n"];
    return text;
}
+ (NSString *)modelCreatReadDataHaveConditionsFromNameAndAtributesDic:(NSDictionary *)nameAndAtributesDicM  withInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"-(%@ *)readDataHaveConditionsWithFMResultSe:(FMResultSet *)set{\n\t%@ *model=[[%@ alloc]init];\n\tNSInteger i=0;\n\twhile ([set next]) {%@\n\t\tif(i++>=self.dataLimiteCount)break;%@\n\t",className,className,className,[FMDBCreat getTabSpaceWithTCount:tCount],[FMDBCreat getTabSpaceWithTCount:tCount]];
    for (NSString *property in [nameAndAtributesDicM allKeys]) {
        [text appendString:@"\tmodel."];
        [text appendString:property];
        [text appendString:@"=[set stringForColumn:@\""];
        [text appendString:property];
        [text appendFormat:@"\"];%@\n\t",[FMDBCreat getTabSpaceWithTCount:tCount]];
    }
    [text appendFormat:@"}\n\treturn model;\n}\n"];
    return text;
}
+ (NSString *)modelCreatDeleteDatawithInsideValue:(NSInteger)tCount withClassName:(NSString *)className{
    NSMutableString *text=[NSMutableString string];
    [text appendFormat:@"- (void)deleteData{\n\tif (![self.database executeUpdate:@\"delete * from %@\"]) {\n\t\tNSLog(@\"删除失败\");\n\t}\n}\n",className];
    return text;
}



+ (NSDictionary *)GetNameAndAtributeFormObject:(id)model{
    NSDictionary *propertyDic=[RunTime allNameAndAtributesFromObject:model];
    return propertyDic;
}
//1.1.如果一个模型里面全部都是字符串,根据这个模型生成  创建表
+ (NSString *)ModelCreatTable:(NSDictionary *)propertyDic{
    NSMutableString *text=[NSMutableString string];
    [text appendString:@"if (![_database executeUpdate:@\"create table if not exists AppTable (id integer primary key autoincrement , "];
    NSInteger count=propertyDic.count;
    for (NSString *property in [propertyDic allKeys]) {
        if([[FMDBCreat getAtributes:propertyDic[property]] isEqualToString:@"NSString"])
            [text appendString:property];
        else if([[FMDBCreat getAtributes:propertyDic[property]] isEqualToString:@"NSMutableDictionary"]||[[FMDBCreat getAtributes:propertyDic[property]] isEqualToString:@"NSDictionary"]){
            [text appendString: @" Dictionary"];[text appendString:property];
        }
        else if([[FMDBCreat getAtributes:propertyDic[property]] isEqualToString:@"NSMutableArray"]||[[FMDBCreat getAtributes:propertyDic[property]] isEqualToString:@"NSArray"]){
            [text appendString: @" Array"];[text appendString:property];
        }
        [text appendString: @" text"];
        if(count!=1)[text appendString:@","];
        count--;
    }
    [text appendString:@")\"]) {\n\tNSLog(@\"创建表失败\");\n}\n"];
    return text;
}
//1.2.如果一个模型里面全部都是字符串,根据这个模型生成  插入数据
+ (NSString *)ModelInsertData:(NSDictionary *)propertyDic{
    NSMutableString *text=[NSMutableString string];
    [text appendString:@"if (![_database executeUpdate:@\"insert into AppTable ("];
    NSInteger count=propertyDic.count;
    for (NSString *property in [propertyDic allKeys]) {
        [text appendString:property];
        if(count!=1) [text appendString: @","];
        else [text appendString:@") values ("];
        count--;
    }
    count=propertyDic.count;
    for(NSInteger i=0;i<count;i++){
        if(count!=1)[text appendString: @"?,"];
        else [text appendString: @"?)"];
    }
    count=propertyDic.count;
    for (NSString *property in [propertyDic allKeys]) {
        [text appendString: @"appdata."];//这里需要一个模型名字
        [text appendString:property];
        if(count!=1) [text appendString: @","];
        else [text appendString:@"]) {\n\tNSLog(@\"插入失败\");\n}\n"];
        count--;
    }
    return text;
}
//1.3.如果一个模型里面全部都是字符串,根据这个模型生成  读取数据
+ (NSString *)ModelReadData:(NSDictionary *)propertyDic{
    NSMutableString *text=[NSMutableString string];
    [text appendString:@"FMResultSet *set = [self.database executeQuery:@\"select * from AppTable where typeMyApp=?\",self.flag];\n\twhile ([set next]) {\n\t\tappDataModel *model=[[appDataModel alloc]init];\n\t\t"];
    for (NSString *property in [propertyDic allKeys]) {
        [text appendString:@"model."];
        [text appendString:property];
        [text appendString:@"=[set stringForColumn:@\""];
        [text appendString:property];
        [text appendString:@"\"];\n\t\t"];
    }
    [text appendString:@"[self.arrData addObject:model];"];
    return text;
}
//1.4.如果一个模型里面全部都是字符串,根据这个模型生成  删除表格
+ (NSString *)ModelDeleteData:(NSDictionary *)propertyDic{
    NSMutableString *text=[NSMutableString string];
    [text appendString:@"if (![self.database executeUpdate:@\"delete from AppTable where typeMyApp=?\",self.flag]) {\n\tNSLog(@\"删除失败\");\n}\n"];
    return text;
}
//辅助函数
+ (NSString *)getAtributes:(NSString *)text{
    if([text hasPrefix:@"T@"]){//OC对象
        NSString *myText=[text substringFromIndex:3];
        if([myText rangeOfString:@"\""].location!=NSNotFound)
            myText=[myText substringToIndex:[myText rangeOfString:@"\""].location];
        NSLog(@"%@",myText);
        return myText;
    }else{
        return @"";//再说
    }
    return @"";
}
@end