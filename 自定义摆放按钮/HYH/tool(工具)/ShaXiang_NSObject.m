//
//  ShaXiang_NSObject.m
//  CZYTH_04
//
//  Created by yu on 15/9/6.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import "ShaXiang_NSObject.h"

@implementation ShaXiang_NSObject

/**
 *  获取document目录路径
 *
 *  @return <#return value description#>
 */
-(NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


/**
 *  路径是否需要创建
 *
 *  @param dirPath <#dirPath description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)isDirNeedCreate:(NSString *)dirPath
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:dirPath] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return NO;
}

//文件是否需要创建
-(BOOL)isFileNeedCreate:(NSString *)filePath{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:filePath] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    return NO;
}

/**
 *  添加数据
 */
-(void) doAdd{
    
    NSString *docPath=[self docPath];
    NSLog(@"当前docment路径：\n%@",docPath);
    NSString *dataFile=[docPath stringByAppendingPathComponent:@"docData.plist"];
    
    if (YES==[self isFileNeedCreate:dataFile]) {
        NSLog(@"文件原先不存在，现已新建空文件！");
    }else{
        NSLog(@"文件已存在，无需创建！");
    }
    
    NSMutableDictionary *plistDic = [[NSMutableDictionary alloc ] init];
    // 添加2个“单条记录”
    [plistDic setObject:@"shanghai" forKey:@"recordKey001"];
    [plistDic setObject:@"beijing" forKey:@"recordKey002"];
    // 添加2个“字典记录”
    [plistDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Jack",@"name",@"22",@"age",nil] forKey:@"dicKey001"];
    [plistDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Tom",@"name",@"33",@"age",nil] forKey:@"dicKey002"];
    
    [plistDic writeToFile:dataFile atomically:YES];//完全覆盖
    NSLog(@"添加内容完成！！");
}

/**
 *  读取数据
 */
-(void) doRead{
    NSString *dataFile=[[self docPath] stringByAppendingPathComponent:@"docData.plist"];
    
    //读取所有内容
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    NSLog(@"完整内容:\n%@",dic);
    
    //读取第一层“字典记录”
    NSDictionary* dicValue=[dic objectForKey:@"dicKey001"];
    NSLog(@"读取第一层“字典记录”:\n%@",dicValue);
    
    //读取第一层“字典记录”中的“子元素”
    NSLog(@"读取第一层“字典记录”中的“子元素”:\nname=%@",[dicValue objectForKey:@"name" ]);
    
    //读取第一层“单条记录”
    NSLog(@"读取第一层“单条记录”:\nrecordKey001=%@",[dic objectForKey:@"recordKey001"]);
}

/**
 *  修改数据
 */
-(void) doModify{
    NSString *dataFile=[[self docPath] stringByAppendingPathComponent:@"docData.plist"];
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc]initWithContentsOfFile:dataFile]mutableCopy];
    
    //修改“单条记录”
    NSString *city = [dic objectForKey:@"recordKey001"];
    city = @"shanghai-new";
    [dic setObject:city forKey:@"recordKey001"];
    //修改“字典记录”
    NSMutableDictionary *personInfo = [dic objectForKey:@"dicKey001"];
    NSString *name = [dic objectForKey:@"name"];
    name = @"Jack-new";
    [personInfo setValue:name forKey:@"name"];
    [dic setValue:personInfo forKey:@"dicKey001"];
    //写入文件
    [dic writeToFile:dataFile atomically:YES];
    
    NSDictionary* dicResult = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    NSLog(@"修改结果:\n%@",dicResult);
}

/**
 *  删除数据
 */
-(void) doDelete{
    NSString *dataFile=[[self docPath] stringByAppendingPathComponent:@"docData.plist"];
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc]initWithContentsOfFile:dataFile]mutableCopy];
    //删除“单条记录”
    [dic removeObjectForKey:@"recordKey001"];
    [dic removeObjectForKey:@"dicKey001"];
    //删除“字典记录”
    
    //写入文件
    [dic writeToFile:dataFile atomically:YES];
    
    NSDictionary* dicResult = [NSDictionary dictionaryWithContentsOfFile:dataFile];
    NSLog(@"修改结果:\n%@",dicResult);
}
@end
