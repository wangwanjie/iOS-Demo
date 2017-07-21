//
//  JoDes.h
//  Bus100
//
//  Created by wxj on 15/4/13.
//  Copyright (c) 2015年 BSYB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface JoDes : NSObject

+ (NSString *) encode:(NSString *)str key:(NSString *)key; // 加密算法
+ (NSString *) decode:(NSString *)str key:(NSString *)key; // 解密算法
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;  //  json 字符串转化为字典
+ (NSArray *)arrayWithJsonString:(NSString *)string;  // json字符串转化为数组
+ (NSMutableString *)urlEncode:(NSString*)str;
+ (NSString *)encodeBase64WithData:(NSData *)objData;
/**
 *
 *    封住加密方法
 *
 */

+ (NSMutableDictionary *)endictionaryWithParmas:(NSMutableDictionary *)dictionary WithService:(NSString *)service;

/**
 *
 *    解密方法
 *
 */

+ (NSDictionary *)deDictionaryWithParmas:(NSString *)commentStr;


+ (NSString *)deStringWithParmas:(NSString *)commentStr;
@end
