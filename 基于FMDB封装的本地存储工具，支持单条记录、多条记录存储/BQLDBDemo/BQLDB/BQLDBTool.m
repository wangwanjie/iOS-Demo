//
//  BQLDBTool.m
//  BQLDB
//
//  Created by 毕青林 on 16/5/31.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "BQLDBTool.h"
#import "FMDB.h"
#import "BQLDBModel.h"
#import "BQLElseTool.h"

static FMDatabase *_fmdb;

// 默认数据库主键为:id (这里使用id作为主键那你的模型就避免使用id作为key了,若有冲突请自行修改这里的主键)
static NSString *PRIMARYKEY = @"id";

@interface BQLDBTool ()
{
    NSString *_currentDBPath;
}

@end

@implementation BQLDBTool

+ (instancetype)instantiateTool {
    
    static BQLDBTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[self.class alloc] init];
    });
    return tool;
}

- (void)openDBWith:(NSString *)dbName Model:(BQLDBModel *)model {
    
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bqldb.sqlite"];
    NSLog(@"path:%@",filePath);
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    
#pragma 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@(%@ INTEGER PRIMARY KEY,",dbPath,PRIMARYKEY];
    
    // 增加一个附加主键区别渐变主键id(作用与id一样,不过id你不能当做模型属性取出来而它可以)
    sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@ INTEGER NOT NULL,",[[BQLDBModel getAllKeys] firstObject]]];
    for(int i = 0; i < [model getAllKeys].count; i ++) {
        
        id value = [model getAllValues][i];
        NSString *type = getDBKeyType(value);
        
        if(i == [model getAllKeys].count - 1) {
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@ %@ NOT NULL);",[model getAllKeys][i],type]];
        }
        else {
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@ %@ NOT NULL,",[model getAllKeys][i],type]];
        }
    }
    [_fmdb executeUpdate:sql];
    
    [_fmdb close];
}

/**
 *  如果有新增字段要先在表中新增字段,在执行更新
 *
 *  @param dbPath 表路径
 *  @param model  建表模型
 */
+ (void)checkIfAlertTableWith:(NSString *)dbPath Model:(BQLDBModel *)model {
    
    NSArray *newColmun = [[self class] searchNewColumn:dbPath Model:model];
    for (int i = 0; i < newColmun.count; i ++) {
        
        id value = [model getAllValues][i];
        NSString *type = getDBKeyType(value);
        NSString *alertsql = [NSString stringWithFormat:@"ALTER TABLE t_%@ ADD COLUMN %@ %@",dbPath,newColmun[i],type];
        if(![_fmdb executeUpdate:alertsql]) NSLog(@"error:%@",_fmdb.lastErrorMessage);
    }
}

- (BOOL)insertDataWith:(NSString *)dbName Model:(BQLDBModel *)model {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    // 如果有新增字段要先在表中新增字段,在执行更新
    [[self class] checkIfAlertTableWith:dbPath Model:model];
    
    // 下面的步骤是拼接sql语句
    NSArray *keys = [model getAllKeys];
    NSArray *values = [model getAllValues];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_%@",dbPath];
    NSString *keyParameter = @"(";
    NSString *keyNoSureParameter = @"(";
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
    
    // 增加一个附加主键区别渐变主键id(作用与id一样,不过id你不能当做模型属性取出来而它可以)
    keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",[[BQLDBModel getAllKeys] firstObject]]];
    keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
    [valuesArray addObject:[NSNumber numberWithLongLong:[[self class] getMaxID:dbPath]]];
    
    for (int i = 0; i < keys.count; i ++) {
        
        if(i == keys.count - 1) {
            
            keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@)",keys[i]]];
            keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?)"];
        }
        else {
            
            keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",keys[i]]];
            keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
        }
        // 添加数据
        [valuesArray addObject:values[i]];
    }
    // sql是最终拼接好的sql语句
    sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ VALUES %@",keyParameter,keyNoSureParameter]];
    BOOL isSuccess = [_fmdb executeUpdate:sql withArgumentsInArray:valuesArray];
    if(!isSuccess) NSLog(@"error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isSuccess;
}

- (BOOL)insertDataWithBatch:(NSString *)dbName DataArray:(NSArray *)dataArray UseTransaction:(BOOL )useTransaction {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    BQLDBModel *model = [dataArray firstObject];
    // 如果有新增字段要先在表中新增字段,在执行更新
    [[self class] checkIfAlertTableWith:dbPath Model:model];
    
    __block BOOL isInsertSuccess = YES;
    if(useTransaction) {
        
        // 使用事务处理
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bqldb.sqlite"];
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        
        int64_t customid = [[self class] getMaxID:dbPath];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            for (int i = 0; i < dataArray.count; i ++) {
                
                BQLDBModel *tempModel = dataArray[i];
                // 下面的步骤是拼接sql语句
                NSArray *keys = [tempModel getAllKeys];
                NSArray *values = [tempModel getAllValues];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_%@",dbPath];
                NSString *keyParameter = @"(";
                NSString *keyNoSureParameter = @"(";
                NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
                
                // 增加一个附加主键区别渐变主键id(作用与id一样,不过id你不能当做模型属性取出来而它可以)
                keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",[[BQLDBModel getAllKeys] firstObject]]];
                keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
                [valuesArray addObject:@(customid + i)];
                //[valuesArray addObject:[NSNumber numberWithLongLong:[[self class] getMaxID:dbPath]]];
                
                for (int i = 0; i < keys.count; i ++) {
                    
                    if(i == keys.count - 1) {
                        
                        keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@)",keys[i]]];
                        keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?)"];
                    }
                    else {
                        
                        keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",keys[i]]];
                        keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
                    }
                    // 添加数据
                    [valuesArray addObject:values[i]];
                }
                // sql是最终拼接好的sql语句
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ VALUES %@",keyParameter,keyNoSureParameter]];
                
                BOOL isSuccess = [db executeUpdate:sql withArgumentsInArray:valuesArray];
                if(!isSuccess) {
                    
                    *rollback = YES;
                    isInsertSuccess = NO;
                    return ;
                }
            }
        }];
    }
    else {
        
        // 不使用事务处理
        for (int i = 0; i < dataArray.count; i ++) {
            
            BQLDBModel *tempModel = dataArray[i];
            // 下面的步骤是拼接sql语句
            NSArray *keys = [tempModel getAllKeys];
            NSArray *values = [tempModel getAllValues];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_%@",dbPath];
            NSString *keyParameter = @"(";
            NSString *keyNoSureParameter = @"(";
            NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
            
            // 增加一个附加主键区别渐变主键id(作用与id一样,不过id你不能当做模型属性取出来而它可以)
            keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",[[BQLDBModel getAllKeys] firstObject]]];
            keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
            [valuesArray addObject:[NSNumber numberWithLongLong:[[self class] getMaxID:dbPath]]];
            
            for (int i = 0; i < keys.count; i ++) {
                
                if(i == keys.count - 1) {
                    
                    keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@)",keys[i]]];
                    keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?)"];
                }
                else {
                    
                    keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",keys[i]]];
                    keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
                }
                // 添加数据
                [valuesArray addObject:values[i]];
            }
            // sql是最终拼接好的sql语句
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ VALUES %@",keyParameter,keyNoSureParameter]];
            
            BOOL isSuccess = [_fmdb executeUpdate:sql withArgumentsInArray:valuesArray];
            if(!isSuccess) {
                
                isInsertSuccess = NO;
            }
        }
    }
    
    [_fmdb close];
    return isInsertSuccess;
}

- (BOOL)insertDataWithBatch:(NSString *)dbName DataArray:(NSArray *)dataArray UseTransaction:(BOOL )useTransaction Progress:(void(^)(double progress))progress {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    BQLDBModel *model = [dataArray firstObject];
    // 如果有新增字段要先在表中新增字段,在执行更新
    [[self class] checkIfAlertTableWith:dbPath Model:model];
    
    __block BOOL isInsertSuccess = YES;
    __block NSInteger current = 0;
    if(useTransaction) {
        
        // 使用事务处理
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bqldb.sqlite"];
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        
        int64_t customid = [[self class] getMaxID:dbPath];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            for (int i = 0; i < dataArray.count; i ++) {
                
                BQLDBModel *tempModel = dataArray[i];
                // 下面的步骤是拼接sql语句
                NSArray *keys = [tempModel getAllKeys];
                NSArray *values = [tempModel getAllValues];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_%@",dbPath];
                NSString *keyParameter = @"(";
                NSString *keyNoSureParameter = @"(";
                NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
                
                // 增加一个附加主键区别渐变主键id(作用与id一样,不过id你不能当做模型属性取出来而它可以)
                keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",[[BQLDBModel getAllKeys] firstObject]]];
                keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
                [valuesArray addObject:@(customid + i)];
                //[valuesArray addObject:[NSNumber numberWithLongLong:[[self class] getMaxID:dbPath]]];
                
                for (int i = 0; i < keys.count; i ++) {
                    
                    if(i == keys.count - 1) {
                        
                        keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@)",keys[i]]];
                        keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?)"];
                    }
                    else {
                        
                        keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",keys[i]]];
                        keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
                    }
                    // 添加数据
                    [valuesArray addObject:values[i]];
                }
                // sql是最终拼接好的sql语句
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ VALUES %@",keyParameter,keyNoSureParameter]];
                
                BOOL isSuccess = [db executeUpdate:sql withArgumentsInArray:valuesArray];
                if(!isSuccess) {
                    
                    *rollback = YES;
                    isInsertSuccess = NO;
                    return ;
                }
                current ++;
                progress(((double)current / (double)dataArray.count));
            }
        }];
    }
    else {
        
        // 不使用事务处理
        for (int i = 0; i < dataArray.count; i ++) {
            
            BQLDBModel *tempModel = dataArray[i];
            // 下面的步骤是拼接sql语句
            NSArray *keys = [tempModel getAllKeys];
            NSArray *values = [tempModel getAllValues];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_%@",dbPath];
            NSString *keyParameter = @"(";
            NSString *keyNoSureParameter = @"(";
            NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
            
            // 增加一个附加主键区别渐变主键id(作用与id一样,不过id你不能当做模型属性取出来而它可以)
            keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",[[BQLDBModel getAllKeys] firstObject]]];
            keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
            [valuesArray addObject:[NSNumber numberWithLongLong:[[self class] getMaxID:dbPath]]];
            
            for (int i = 0; i < keys.count; i ++) {
                
                if(i == keys.count - 1) {
                    
                    keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@)",keys[i]]];
                    keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?)"];
                }
                else {
                    
                    keyParameter = [keyParameter stringByAppendingString:[NSString stringWithFormat:@"%@, ",keys[i]]];
                    keyNoSureParameter = [keyNoSureParameter stringByAppendingString:@"?,"];
                }
                // 添加数据
                [valuesArray addObject:values[i]];
            }
            // sql是最终拼接好的sql语句
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ VALUES %@",keyParameter,keyNoSureParameter]];
            
            BOOL isSuccess = [_fmdb executeUpdate:sql withArgumentsInArray:valuesArray];
            if(!isSuccess) {
                
                isInsertSuccess = NO;
            }
            current ++;
            progress(((double)current / (double)dataArray.count));
        }
    }
    
    [_fmdb close];
    return isInsertSuccess;
}

- (BOOL)deleteDataWith:(NSString *)dbName {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    BOOL isSuccess = [_fmdb executeUpdate:[NSString stringWithFormat:@"DELETE FROM t_%@",dbPath]];
    if(!isSuccess) NSLog(@"error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isSuccess;
}

- (BOOL)deleteDataWith:(NSString *)dbName Identifier:(NSString *)identifier IdentifierValue:(NSString *)identifierValue {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSString *deletesql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE %@ = %@",dbPath,checkObjectNotNull(identifier)?identifier:PRIMARYKEY,identifierValue];
    BOOL isDelete = [_fmdb executeUpdate:deletesql];
    if(!isDelete) NSLog(@"delete data error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isDelete;
}

- (BOOL)delectDataWithBatch:(NSString *)dbName Identifier:(NSString *)identifier IdentifierValues:(NSArray *)identifierValues {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    __block BOOL isDeleteSuccess = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < identifierValues.count; i ++) {
            
            NSString *deletesql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE %@ = %@",dbPath,checkObjectNotNull(identifier)?identifier:PRIMARYKEY,identifierValues[i]];
            BOOL isDelete = [db executeUpdate:deletesql];
            if(!isDelete) {
                *rollback = YES;
                isDeleteSuccess = NO;
                return ;
            }
        }
        
    }];
    
    [_fmdb close];
    return isDeleteSuccess;
}

- (BOOL)modifyDataWith:(NSString *)dbName Model:(BQLDBModel *)model {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSArray *keys = [model getAllKeys];
    NSArray *values = [model getAllValues];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_%@ SET ",dbPath];
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < keys.count; i ++) {
        
        if(i == keys.count - 1) {
            
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = ?",keys[i]]];
        }
        else {
            
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = ?, ",keys[i]]];
        }
        // 添加数据
        [valuesArray addObject:values[i]];
    }
    BOOL isModifySuccess = [_fmdb executeUpdate:sql withArgumentsInArray:valuesArray];
    if(!isModifySuccess) NSLog(@"modify error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isModifySuccess;
}


- (BOOL)modifyDataWith:(NSString *)dbName Model:(BQLDBModel *)model Identifier:(NSString *)identifier IdentifierValue:(NSString *)identifierValue {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSArray *keys = [model getAllKeys];
    NSArray *values = [model getAllValues];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_%@ SET ",dbPath];
    NSMutableArray *valuesArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < keys.count; i ++) {
        
        if(i == keys.count - 1) {
            
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = ? WHERE %@ = %@",keys[i],checkObjectNotNull(identifier)?identifier:PRIMARYKEY,identifierValue]];
        }
        else {
            
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = ?, ",keys[i]]];
        }
        // 添加数据
        [valuesArray addObject:values[i]];
    }
    BOOL isModifySuccess = [_fmdb executeUpdate:sql withArgumentsInArray:valuesArray];
    if(!isModifySuccess) NSLog(@"modify error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isModifySuccess;
}

- (BOOL)modifyDataWith:(NSString *)dbName Key:(NSString *)key Value:(id )value {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_%@ SET %@ = ? WHERE id = 1",dbPath,key];
    
    BOOL isModifySuccess = [_fmdb executeUpdate:sql withArgumentsInArray:@[value]];
    if(!isModifySuccess) NSLog(@"modify error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isModifySuccess;
}

- (BOOL)modifyDataWith:(NSString *)dbName Key:(NSString *)key Value:(id )value Identifier:(NSString *)identifier IdentifierValue:(NSString *)identifierValue {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_%@ SET %@ = ? WHERE %@ = %@",dbPath,key,checkObjectNotNull(identifier)?identifier:PRIMARYKEY,identifierValue];
    
    BOOL isModifySuccess = [_fmdb executeUpdate:sql withArgumentsInArray:@[value]];
    if(!isModifySuccess) NSLog(@"modify error:%@",_fmdb.lastErrorMessage);
    
    [_fmdb close];
    return isModifySuccess;
}


- (BOOL)modifyDataWithBatch:(NSString *)dbName Key:(NSArray *)keys Value:(NSArray *)values Identifier:(NSString *)identifier IdentifierValue:(NSString *)identifierValue {
    
    if(keys.count != values.count) return NO;
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    // 批量用事务处理
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    __block BOOL isModifySuccess = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < keys.count; i ++) {
            
            NSString *sql = [NSString stringWithFormat:@"UPDATE t_%@ SET %@ = '%@' WHERE %@ = %@",dbPath,keys[i],values[i],checkObjectNotNull(identifier)?identifier:PRIMARYKEY,identifierValue];
            NSLog(@"sql:%@",sql);
            BOOL isSuccess = [db executeUpdate:sql];
            if(!isSuccess) {
                
                *rollback = YES;
                isModifySuccess = NO;
                return ;
            }
        }
        
    }];
    
    [_fmdb close];
    return isModifySuccess;
}

- (BOOL)modifyDataWithBatch:(NSString *)dbName KeyValue:(NSDictionary *)keyValue Identifier:(NSString *)identifier IdentifierValue:(NSString *)identifierValue {
    
    if([[keyValue allKeys] count] != [[keyValue allValues] count]) return NO;
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    NSString *dbPath = [[self class] getValidDBName:dbName];
    
    // 批量用事务处理
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    __block BOOL isModifySuccess = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (int i = 0; i < [[keyValue allKeys] count]; i ++) {
            
            NSString *sql = [NSString stringWithFormat:@"UPDATE t_%@ SET %@ = '%@' WHERE %@ = %@",dbPath,[keyValue allKeys][i],[keyValue allValues][i],checkObjectNotNull(identifier)?identifier:PRIMARYKEY,identifierValue];
            NSLog(@"sql:%@",sql);
            BOOL isSuccess = [db executeUpdate:sql];
            if(!isSuccess) {
                
                *rollback = YES;
                isModifySuccess = NO;
                return ;
            }
        }
        
    }];
    
    [_fmdb close];
    return isModifySuccess;
}

- (NSArray *)queryDataWith:(NSString *)dbName {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_%@",dbPath];
    NSMutableArray *dataArray = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSArray *dbkeysArray = [[self class] searchDBColumns:dbName];
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        for (NSString *key in dbkeysArray) {
            
            id value = [set objectForColumnName:key];
            [dataDictionary setValue:value forKey:key];
        }
        
        [dataArray addObject:dataDictionary];
    }
    
    [_fmdb close];
    return dataArray;
}

/*
 *  如果数据库没有打开，先打开数据再进行操作
 */
+ (void)opDBWith:(NSString *)dbName {
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bqldb.sqlite"];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
}

/*
 *  检索新增字段,若有则返回新增字段数组,若没有,返回空数组
 */
+ (NSArray *)searchNewColumn:(NSString *)dbName Model:(BQLDBModel *)model {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    
    NSString *sqlstr = [NSString stringWithFormat:@"select * from t_%@",dbName];
    FMResultSet *result = [_fmdb executeQuery:sqlstr];
    
    NSMutableArray *newColumnArray = [NSMutableArray arrayWithArray:@[]];
    NSArray *keys = [model getAllKeys];
    for (int i = 0; i < keys.count; i ++) {
        
        NSString *key = keys[i];
        [result columnIndexForName:key];
        NSDictionary *dict = [result columnNameToIndexMap];
        if(dict) {
            
            NSArray *dictKeys = [dict allKeys];
            if(![dictKeys containsObject:[key lowercaseString]]) {
                
                [newColumnArray addObject:key];
            }
        }
    }
    
    //[_fmdb close];
    return newColumnArray;
}

/*
 *  获取表中所有字段,返回数组
 */
+ (NSArray *)searchDBColumns:(NSString *)dbName {
    
    if(![_fmdb open]) {
        [[self class] opDBWith:dbName];
    }
    // 处理不同表命名(name、name.sqlite)获取有效表名
    NSString *dbPath = [[self class] getValidDBName:dbName];
    NSString *sqlstr = [NSString stringWithFormat:@"select * from t_%@",dbPath];
    FMResultSet *result = [_fmdb executeQuery:sqlstr];
    NSDictionary *dict = [result columnNameToIndexMap];
    return [dict allKeys];
}

/*
 *  如果你喜欢用其他表命名请在这个方法修改
 */
+ (NSString *)getValidDBName:(NSString *)dbName {
    
    NSArray *dbNameArray = [dbName componentsSeparatedByString:@"."];
    NSString *dbPath = [dbNameArray firstObject];
    return dbPath;
}

+ (int64_t )getMaxID:(NSString *)dbName {
    
    NSString *sql = [NSString stringWithFormat:@"select max(%@) max from t_%@",PRIMARYKEY,dbName];
    
    __block int64_t max = 0;
    [_fmdb executeStatements:sql withResultBlock:^int(NSDictionary *resultsDictionary) {
        
        if(resultsDictionary) {
            
            if(checkObjectNotNull(resultsDictionary[@"max"])) {
                
                max = (int64_t)([resultsDictionary[@"max"] integerValue]);
            }
        }
        return 0;
    }];
    
    return max + 1;
}

@end

















