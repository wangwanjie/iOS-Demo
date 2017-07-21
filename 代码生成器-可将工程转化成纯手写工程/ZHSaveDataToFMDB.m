#import "ZHSaveDataToFMDB.h"
#define FilePath [NSHomeDirectory() stringByAppendingFormat:@"/Documents/FMDBTemp"]
@implementation ZHSaveDataToFMDB

#pragma mark ----------保存数据
//保存缓存数据:(字典,数组,JSon字符串) 其中中间过程会产生一个临时的文件(速度稍慢)
+ (void)saveDataHasTempFileWithData:(id)data WithIdentity:(NSString *)identity{
    //如果已经存在,先删除,这样可以认为是更新
    if([self exsistDataWithIdentity:identity])[self deleteDataWithIdentity:identity];
    
    //如果数据是字符串,直接保存
    if([data isKindOfClass:[NSString class]]){
        NSString *code=[NSString stringWithFormat:@"insert into %@ (JSONData,DataType,Identity) values ('%@','%@','%@')",TableName,[self enCode:(NSString *)data],@"NSString",identity];
        if (![[self getDataBase] executeUpdate:code]) {
            [self showAlertMessage:@"保存数据失败"];
        }
    }
    //如果数据是字典
    else if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *tempDic=(NSDictionary *)data;
        NSString *RandFileName=[FilePath stringByAppendingString:[NSString stringWithFormat:@"%d.txt",abs(arc4random())]];
        [tempDic writeToFile:RandFileName atomically:YES];
        NSString *text=[NSString stringWithContentsOfFile:RandFileName encoding:NSUTF8StringEncoding error:nil];
        NSString *code=[NSString stringWithFormat:@"insert into %@ (JSONData,DataType,Identity) values ('%@','%@','%@')",TableName,[self enCode:text],@"NSDictionary",identity];
        if (![[self getDataBase] executeUpdate:code]) {
            [self showAlertMessage:@"插入失败"];
        }
        [[NSFileManager defaultManager]removeItemAtPath:RandFileName error:nil];
    }else if([data isKindOfClass:[NSArray class]]){
        NSArray *tempArr=(NSArray *)data;
        NSString *RandFileName=[FilePath stringByAppendingString:[NSString stringWithFormat:@"%d.txt",abs(arc4random())]];
        [tempArr writeToFile:RandFileName atomically:YES];
        NSString *text=[NSString stringWithContentsOfFile:FilePath encoding:NSUTF8StringEncoding error:nil];
        NSString *code=[NSString stringWithFormat:@"insert into %@ (JSONData,DataType,Identity) values ('%@','%@','%@')",TableName,[self enCode:text],@"NSArray",identity];
        if (![[self getDataBase] executeUpdate:code]) {
            [self showAlertMessage:@"插入失败"];
        }
        [[NSFileManager defaultManager]removeItemAtPath:RandFileName error:nil];
    }
}
//保存缓存数据:(网址) 其中中间过程会产生一个临时的文件(速度稍慢)
+ (void)saveDataHasTempFileWithURL:(NSString *)URL WithIdentity:(NSString *)identity{
    if([self exsistDataWithIdentity:identity])[self deleteDataWithIdentity:identity];
    NSString *text=[NSString stringWithContentsOfURL:[NSURL URLWithString:URL] encoding:NSUTF8StringEncoding error:nil];
    NSString *code=[NSString stringWithFormat:@"insert into %@ (JSONData,DataType,Identity) values ('%@','%@','%@')",TableName,[self enCode:text],@"URL",identity];
    if (![[self getDataBase] executeUpdate:code]) {
        [self showAlertMessage:@"插入失败"];
    }
}

////保存缓存数据:(字典,数组,JSon字符串) 其中中间过程不会产生一个临时的文件(速度较快)
+ (void)insertDataWithData:(id)data WithIdentity:(NSString *)identity{
    if([self exsistDataBLOBWithIdentity:identity])[self deleteBLOBDataWithIdentity:identity];
    if([data isKindOfClass:[NSString class]]){
        NSData *myData=[data dataUsingEncoding:NSUTF8StringEncoding];
        NSString *code=[NSString stringWithFormat:@"insert into %@ (DataType,Identity,JSONBLOBData) values ('%@','%@','%@')",TableNameBLOB,@"NSString",identity,myData];
        if (![[self getDataBase] executeUpdate:code]) {
            [self showAlertMessage:@"插入失败"];
        }
    }else if([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *tempDic=(NSDictionary *)data;
        NSData *myData=[NSKeyedArchiver archivedDataWithRootObject:tempDic];
        if(myData==nil){
            [self showAlertMessage:@"归档失败"];
            return;
        }
        //注意:我这里被坑了好久,%@来格式化二进制会被格式化成字符串(总之,要想存储二进制,不能使用下面的这句语句)
        
        //错误示范
        //        NSString *code=[NSString stringWithFormat:@"insert into %@ (DataType,Identity,JSONBLOBData) values ('%@','%@','%@')",TableNameBLOB,@"NSDictionary",identity,myData];
        
        if (![[self getDataBase] executeUpdate:@"insert into ZHJSONBLOB (DataType,Identity,JSONBLOBData) values (?,?,?)",@"NSDictionary",identity,myData]) {
            [self showAlertMessage:@"插入失败"];
        }
    }else if([data isKindOfClass:[NSArray class]]){
        NSArray *tempArr=(NSArray *)data;
        
        NSData *myData=[NSKeyedArchiver archivedDataWithRootObject:tempArr];
        if(myData==nil){
            [self showAlertMessage:@"归档失败"];
            return;
        }
        if (![[self getDataBase] executeUpdate:@"insert into ZHJSONBLOB (DataType,Identity,JSONBLOBData) values (?,?,?)",@"NSArray",identity,myData]) {
            [self showAlertMessage:@"插入失败"];
        }
    }
}
////保存缓存数据:(网址) 其中中间过程不会产生一个临时的文件(速度较快)
+ (void)insertDataWithURL:(NSString *)URL WithIdentity:(NSString *)identity{
    if([self exsistDataBLOBWithIdentity:identity])[self deleteBLOBDataWithIdentity:identity];
    NSString *text=[NSString stringWithContentsOfURL:[NSURL URLWithString:URL] encoding:NSUTF8StringEncoding error:nil];
    NSData *myData=[text dataUsingEncoding:NSUTF8StringEncoding];
    if (![[self getDataBase] executeUpdate:@"insert into ZHJSONBLOB (DataType,Identity,JSONBLOBData) values (?,?,?)",@"URL",identity,myData]) {
        [self showAlertMessage:@"插入失败"];
    }
}


#pragma mark ----------读取数据
//将读取出来的数据直接赋值给模型(中间会产生一个临时的文件)
+ (BOOL)readDataWithIdentity:(NSString *)identity toModel:(id)model{
    id obj=[self readDataWithIdentity:identity];
    if(obj!=nil){
        if([obj isKindOfClass:[NSDictionary class]]){
            [model setValuesForKeysWithDictionary:(NSDictionary *)obj];
            return YES;
        }else{
            [self showAlertMessage:@"模型setValuesForKeysWithDictionary的数据不是Dictionary"];
            return NO;
        }
    }else{
        return NO;
    }
}
//将读取出来的数据直接赋值给模型(中间不会产生一个临时的文件)
+ (BOOL)selectDataWithIdentity:(NSString *)identity toModel:(id)model{
    id obj=[self selectDataWithIdentity:identity];
    if(obj!=nil){
        if([obj isKindOfClass:[NSDictionary class]]){
            [model setValuesForKeysWithDictionary:(NSDictionary *)obj];
            return YES;
        }else{
            [self showAlertMessage:@"模型setValuesForKeysWithDictionary的数据不是Dictionary"];
            return NO;
        }
    }else{
        return NO;
    }
}

#pragma mark ----------删除数据
//删除数据(中间会产生一个临时的文件)
+ (void)deleteDataWithIdentity:(NSString *)identity{
    //需要检测是否在删除空数据,因为可能会被误认为删除失败
    NSString *code=[NSString stringWithFormat:@"delete from %@ where Identity = '%@'",TableName,identity];
    if(![[self getDataBase] executeUpdate:code]){
        [self showAlertMessage:[NSString stringWithFormat:@"删除缓存 %@ 失败",identity]];
    }
}
//删除数据(中间不会产生一个临时的文件)
+ (void)deleteBLOBDataWithIdentity:(NSString *)identity{
    //需要检测是否在删除空数据,因为可能会被误认为删除失败
    NSString *codeBLOB=[NSString stringWithFormat:@"delete from %@ where Identity = '%@'",TableNameBLOB,identity];
    if(![[self getDataBase] executeUpdate:codeBLOB]){
        [self showAlertMessage:[NSString stringWithFormat:@"删除缓存 %@ 失败",identity]];
    }
}

#pragma mark ----------清除所有缓存
+ (void)cleanAllData{
    NSString *code=[NSString stringWithFormat:@"delete from %@",TableName];
    if(![[self getDataBase]executeUpdate:code]){
        [self showAlertMessage:@"清除缓存失败"];
    }
    code=[NSString stringWithFormat:@"delete from %@",TableNameBLOB];
    if(![[self getDataBase]executeUpdate:code]){
        [self showAlertMessage:@"清除缓存失败"];
    }
}

//通过使用静态FMDatabase来获取唯一的Database句柄,这个用来操作数据库的
+ (FMDatabase *)getDataBase{
    if (dataBase==nil) {
        dataBase = [[FMDatabase alloc] initWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",DataBaseName]];
        if (![dataBase open]) {
            [self showAlertMessage:@"数据库创建失败"];
        }
        
        //创建两张表:一张是用来保存文本数据的,一张是用来保存二进制数据的
        NSString *code=[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement ,JSONData text,DataType text,Identity text)",TableName];
        if (![dataBase executeUpdate:code]) {
            [self showAlertMessage:@"创建表失败"];
        }
        
        NSString *codeBLOB=[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement ,DataType text,Identity text,JSONBLOBData BLOB)",TableNameBLOB];
        if (![dataBase executeUpdate:codeBLOB]) {
            [self showAlertMessage:@"创建表失败"];
        }
    }
    return dataBase;
}

//测试获取的目标数据是哪张类型
+ (void)testTypeOfDataWithIdentity:(NSString *)identity{
    id obj=[self readDataWithIdentity:identity];
    if([obj isKindOfClass:[NSArray class]]){
        [self showAlertMessage:[NSString stringWithFormat:@"缓存 %@ 返回的是数组(NSArray)",identity]];
    }else if([obj isKindOfClass:[NSDictionary class]]){
        [self showAlertMessage:[NSString stringWithFormat:@"缓存 %@ 返回的是字典(NSDictionary)",identity]];
    }else{
        [self showAlertMessage:[NSString stringWithFormat:@"缓存 %@ 返回的数据有误,请确保存入进去的是数组,字典,URL(JSON),JSON字符串",identity]];
    }
}
//测试获取的目标数据是哪张类型
+ (void)testTypeOfBLOBDataWithIdentity:(NSString *)identity{
    id obj=[self selectDataWithIdentity:identity];
    if([obj isKindOfClass:[NSArray class]]){
        [self showAlertMessage:[NSString stringWithFormat:@"缓存 %@ 返回的是数组(NSArray)",identity]];
    }else if([obj isKindOfClass:[NSDictionary class]]){
        [self showAlertMessage:[NSString stringWithFormat:@"缓存 %@ 返回的是字典(NSDictionary)",identity]];
    }else{
        [self showAlertMessage:[NSString stringWithFormat:@"缓存 %@ 返回的数据有误,请确保存入进去的是数组,字典,URL(JSON),JSON字符串",identity]];
    }
}

//读取数据出来(中间会产生一个临时的文件)
+ (id)readDataWithIdentity:(NSString *)identity{
    NSString *code=[NSString stringWithFormat:@"select * from %@ where Identity='%@'",TableName,identity];
    FMResultSet *set = [[self getDataBase] executeQuery:code];
    NSString *JSONData;
    NSString *DataType;
    while ([set next]) {
        JSONData=[set stringForColumn:@"JSONData"];
        DataType=[set stringForColumn:@"DataType"];
    }
    //开始判断类型
    JSONData=[self deCode:JSONData];
    if([DataType isEqualToString:@"NSString"]){
        return [NSJSONSerialization JSONObjectWithData:[JSONData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }else if([DataType isEqualToString:@"NSDictionary"]){
        NSString *RandFileName=[FilePath stringByAppendingString:[NSString stringWithFormat:@"%d.txt",abs(arc4random())]];
        [JSONData writeToFile:RandFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *tempDic=[NSDictionary dictionaryWithContentsOfFile:RandFileName];
        [[NSFileManager defaultManager]removeItemAtPath:RandFileName error:nil];
        return tempDic;
    }else if([DataType isEqualToString:@"NSArray"]){
        NSString *RandFileName=[FilePath stringByAppendingString:[NSString stringWithFormat:@"%d.txt",abs(arc4random())]];
        [JSONData writeToFile:RandFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSArray *tempArr=[NSArray arrayWithContentsOfFile:RandFileName];
        [[NSFileManager defaultManager]removeItemAtPath:RandFileName error:nil];
        return tempArr;
    }else if([DataType isEqualToString:@"URL"]){
        return [NSJSONSerialization JSONObjectWithData:[JSONData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    return nil;
}
//读取数据出来(中间不会产生一个临时的文件)
+ (id)selectDataWithIdentity:(NSString *)identity{
    NSString *code=[NSString stringWithFormat:@"select * from %@ where Identity='%@'",TableNameBLOB,identity];
    FMResultSet *set = [[self getDataBase] executeQuery:code];
    NSData * JSONData;
    NSString *DataType;
    while ([set next]) {
        JSONData=[set dataForColumn:@"JSONBLOBData"];
        DataType=[set stringForColumn:@"DataType"];
    }
    //开始判断类型
    if([DataType isEqualToString:@"NSString"]){
        return [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }else if([DataType isEqualToString:@"NSDictionary"]){
        NSDictionary *tempDic=[NSKeyedUnarchiver unarchiveObjectWithData:JSONData];
        return tempDic;
    }else if([DataType isEqualToString:@"NSArray"]){
        NSArray *tempArr=[NSKeyedUnarchiver unarchiveObjectWithData:JSONData];
        return tempArr;
    }else if([DataType isEqualToString:@"URL"]){
        return [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    return nil;
}

//判断是否已经存在这条数据
+ (BOOL)exsistDataWithIdentity:(NSString *)identity{
    NSString *code=[NSString stringWithFormat:@"select * from %@ where Identity='%@'",TableName,identity];
    FMResultSet *set = [[self getDataBase] executeQuery:code];
    while ([set next]) {
        return YES;
    }
    return NO;
}
//判断是否已经存在这条数据
+ (BOOL)exsistDataBLOBWithIdentity:(NSString *)identity{
    NSString *code=[NSString stringWithFormat:@"select * from %@ where Identity='%@'",TableNameBLOB,identity];
    FMResultSet *set = [[self getDataBase] executeQuery:code];
    while ([set next]) {
        return YES;
    }
    return NO;
}
//跳出提示框
+(void)showAlertMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//处理数据存储单引号所引起的问题
+ (NSString *)enCode:(NSString *)text{
    NSMutableString *temp=[NSMutableString string];
    NSInteger lenth=text.length;
    unichar ch;
    for(NSInteger i=0;i<lenth;i++){
        ch=[text characterAtIndex:i];
        if(ch=='\''){
            [temp appendString:@"@@"];
        }
        else [temp appendFormat:@"%C",ch];
    }
    return temp;
}
+ (NSString *)deCode:(NSString *)text{
    NSMutableString *temp=[NSMutableString string];
    NSInteger lenth=text.length;
    unichar ch;
    for(NSInteger i=0;i<lenth-1;i++){
        ch=[text characterAtIndex:i];
        if(ch=='@'&&[text characterAtIndex:i+1]=='@'){
            [temp appendString:@"'"];
            i++;
        }
        else [temp appendFormat:@"%C",ch];
    }
    if([text characterAtIndex:lenth-1]!='@')
        [temp appendFormat:@"%C",[text characterAtIndex:lenth-1]];
    return temp;
}
@end
