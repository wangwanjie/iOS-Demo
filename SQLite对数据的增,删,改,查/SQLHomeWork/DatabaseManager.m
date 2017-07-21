//
//  DatabaseManager.m
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "DatabaseManager.h"
#import <sqlite3.h>

static DatabaseManager *instance = nil;

sqlite3 *sqlite = nil;

@implementation DatabaseManager

+(instancetype) shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[DatabaseManager alloc] init];
        
        [instance copyDBFileToSandBox];
    });
    return instance;
}

- (void) copyDBFileToSandBox {
    
    NSString *atPath = [[NSBundle mainBundle] pathForResource:@"mydatabase3" ofType:@"sqlite"];
    NSString *toPath = [self getFileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager moveItemAtPath:atPath toPath:toPath error:nil];
}

- (NSArray *) queryAllModelWithName:(NSString *)username {
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    NSString *fileName = [self getFileName];
    //(1)打开数据库
    int openResult = sqlite3_open([fileName UTF8String], &sqlite);
    if (openResult != SQLITE_OK) {
        
        NSLog(@"打开数据库失败");
    }
    
    //(2)准备SQL语句
    //1> 准备语句
    NSString *statement = @"select * from UserTable where name=?";
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare(sqlite, [statement UTF8String], -1, &stmt, nil);
    
    //2>绑定参数
    sqlite3_bind_text(stmt, 1, [username UTF8String], -1, nil);
    
    //(3)执行sql语句
    int stepResult = sqlite3_step(stmt);
    
    while (stepResult == SQLITE_ROW) {
        
        //拿取数据
        const char *username = (const char *)sqlite3_column_text(stmt, 0);
        const char *password = (const char *)sqlite3_column_text(stmt, 1);
        double age = sqlite3_column_double(stmt, 2);
        
        UserModel *model =[[UserModel alloc] init];
        model.username = [NSString stringWithUTF8String:username];
        model.password = [NSString stringWithUTF8String:password];
        model.age = age;
        
        [mutableArr addObject:model];
        
        stepResult = sqlite3_step(stmt);
    }
    return mutableArr;
}


- (NSArray *) queryAllModel {
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    NSString *fileName = [self getFileName];
    //(1)打开数据库
    int openResult = sqlite3_open([fileName UTF8String], &sqlite);
    if (openResult != SQLITE_OK) {
        
        NSLog(@"打开数据库失败");
    }
    
    //(2)准备SQL语句
    //1> 准备语句
    NSString *statement = @"select * from UserTable";
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare(sqlite, [statement UTF8String], -1, &stmt, nil);
    
    //2>绑定参数
    
    //(3)执行sql语句
    int stepResult = sqlite3_step(stmt);
    
    while (stepResult == SQLITE_ROW) {
        
        //拿取数据
       const char *username = (const char *)sqlite3_column_text(stmt, 0);
       const char *password = (const char *)sqlite3_column_text(stmt, 1);
        double age = sqlite3_column_double(stmt, 2);
        
        UserModel *model =[[UserModel alloc] init];
        model.username = [NSString stringWithUTF8String:username];
        model.password = [NSString stringWithUTF8String:password];
        model.age = age;
        
        [mutableArr addObject:model];
        
        stepResult = sqlite3_step(stmt);
    }
    
    //(4)完结语句
    sqlite3_finalize(stmt);
    
    //(5) 关闭数据库
    sqlite3_close(sqlite);

    
    return mutableArr;
}

- (BOOL) addUserModel:(UserModel *) model{
    
    NSString *fileName = [self getFileName];
    NSLog(@"%@",fileName);
    //(1)打开数据库
    int openResult = sqlite3_open([fileName UTF8String], &sqlite);
    if (openResult != SQLITE_OK) {
        
        NSLog(@"打开数据库失败");
    }
    
    //(2)准备SQL语句
    //1> 准备语句
    NSString *statement = @"insert into UserTable (username,password,age) values (?,?,?)";
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare(sqlite, [statement UTF8String], -1, &stmt, nil);
    
    //2>参数绑定
    sqlite3_bind_text(stmt, 1, [model.username UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [model.password UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 3, model.age);
    
    //(3)执行SQL语句
    int stepResult = sqlite3_step(stmt);
    if (stepResult != SQLITE_OK && stepResult != SQLITE_DONE) {
        NSLog(@"语句执行失败");
        return NO;
    }
    
    //(4)完结语句
    sqlite3_finalize(stmt);
    
    //(5)关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}


- (BOOL) updateUserModel:(UserModel *) model{
    
    NSString *fileName = [self getFileName];
    NSLog(@"%@",fileName);
    //(1)打开数据库
    int openResult = sqlite3_open([fileName UTF8String], &sqlite);
    if (openResult != SQLITE_OK) {
        
        NSLog(@"打开数据库失败");
    }
    
    //(2)准备SQL语句
    //1> 准备语句
    NSString *statement = @"update UserTable set password=?,age=? where username=?";
    sqlite3_stmt *stmt = nil;
    sqlite3_prepare(sqlite, [statement UTF8String], -1, &stmt, nil);
    
    //2>参数绑定
    
    sqlite3_bind_text(stmt, 1, [model.password UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 2, model.age);
    sqlite3_bind_text(stmt, 3, [model.username UTF8String], -1, nil);

    //(3)执行SQL语句
    int stepResult = sqlite3_step(stmt);
    if (stepResult != SQLITE_OK && stepResult != SQLITE_DONE) {
        NSLog(@"语句执行失败");
        return NO;
    }
    
    //(4)完结语句
    sqlite3_finalize(stmt);
    
    //(5)关闭数据库
    sqlite3_close(sqlite);
    
    return YES;
}

- (NSString *) getFileName {
    
    NSString *fileName = [NSHomeDirectory() stringByAppendingString:@"/Documents/userList.sqlite"];
    return fileName;
}

@end
