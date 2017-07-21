//
//  BQLElseTool.m
//  BQLDB
//
//  Created by 毕青林 on 16/6/2.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "BQLElseTool.h"

@implementation BQLElseTool

/*
 根据value判断key类型(如value = @"jack",即key = TEXT;value = @10,即key = INTEGER)
 目前支持以下类型
 TEXT:   值是文本字符串,使用数据库编码(UTF-8,UTF-16BE或者UTF-16LE)存放,最大长度为2^31-1(2,147,483,647)个字符.
 INTEGER:值是有符号整形,根据值的大小以1,2,3,4,6或8字节存放
 REAL:   值是浮点型值,以8字节IEEE浮点数存放
 BLOB:   值是一个数据块,完全按照输入存放（即没有准换,可以存储例如照片data）
 NULL:   值是NULL
 */
NSString *getDBKeyType(id object) {
    
    NSString *objStr = [NSString stringWithFormat:@"%@",object];
    
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"NULL";
    }
    else if (isPureInt(objStr) || [object isKindOfClass:[NSNumber class]]) {
        return @"INTEGER";
    }
    else if (isPureFloat(objStr) || isPureDouble(objStr)) {
        return @"REAL";
    }
    else if ([object isKindOfClass:[NSData class]]) {
        return @"BLOB";
    }
    else if ([object isKindOfClass:[NSString class]] && ![objStr isEqualToString:@""]) {
        return @"TEXT";
    }
    return @"NULL";
    
}

/**
 *  将数组转化为以,分隔的字符串
 *
 *  @param array 接收数组
 *
 *  @return 字符串
 */
NSString *changeToTextSeperateByCommaWithArray(NSArray *array) {
    
    if (array.count>0) {
        
        // 为了和正常字符串区分,加个前缀:BQLDBArray
        NSMutableString *result = [NSMutableString stringWithString:BQLDBPrefixWithArray];
        NSInteger count=0;
        for (id str in array) {
            
            [result appendString:[NSString stringWithFormat:@"%@",str]];
            if (count<array.count-1) {
                [result appendString:@","];
            }
            count++;
        }
        return result;
    }
    else {
        return nil;
    }
}

/**
 *  将字典转换为字符串
 *
 *  @param array 接收字典
 *
 *  @return 字符串
 */
NSString *changeToTextWithDictionary(NSDictionary *dictionary) {
    
    NSData *jsonParameters = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    // 为了和正常字符串区分,加个前缀:BQLDBPrefixWithDictionary
    NSMutableString *dictionaryStr = [NSMutableString stringWithString:BQLDBPrefixWithDictionary];
    [dictionaryStr appendString:[[NSString alloc]initWithData:jsonParameters encoding:NSUTF8StringEncoding]];
    return dictionaryStr;
}

/**
 *  Is Int
 *
 *  @param string string
 *
 *  @return YES or NO
 */
BOOL isPureInt(NSString *string) {
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  Is Float
 *
 *  @param string string
 *
 *  @return YES or NO
 */
BOOL isPureFloat(NSString *string) {
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  Is Double
 *
 *  @param string string
 *
 *  @return YES or NO
 */
BOOL isPureDouble(NSString *string) {
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

/**
 *  Checking NSString、NSNull、NSURL、NSDictionary、NSArray、NSNumber
 *
 *  @param object class
 *
 *  @return YES or NO
 */
BOOL checkObjectNotNull(id object) {
    
    if ([object isKindOfClass:[NSNull class]] || object == nil) {
        return NO;
    }
    else {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)object;
            if ([str isEqualToString:@""]) {
                return NO;
            }
            else {
                return YES;
            }
        }
        else if ([object isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)object;
            if ([[NSString stringWithFormat:@"%@",url] isEqualToString:@""]) {
                return NO;
            }
            else {
                return YES;
            }
        }
        else if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)object;
            if (dic.count <= 0) {
                return NO;
            }
            else {
                return YES;
            }
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)object;
            if (arr.count <= 0) {
                return NO;
            }
            else {
                return YES;
            }
        }
        else if ([object isKindOfClass:[NSNumber class]]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

NSString *getCurrentDBPath() {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"bqldb"];
    NSData  *data = [NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

BOOL setCurrentDBPath(NSString *dbPath) {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dbPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"bqldb"];
    return [data writeToFile:path atomically:YES];
}

NSString *getTodayDate(NSString *format) {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}


@end



