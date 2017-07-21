//
//  ShaXiang_NSObject.h
//  CZYTH_04
//
//  Created by yu on 15/9/6.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ShaXiang_NSObject : NSObject

/**
 *  获取document目录路径
 *
 *  @return <#return value description#>
 */
-(NSString *)docPath;

/**
 *  路径是否需要创建
 *
 *  @param dirPath <#dirPath description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)isDirNeedCreate:(NSString *)dirPath;

/**
 *  文件是否需要创建
 *
 *  @param filePath <#filePath description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)isFileNeedCreate:(NSString *)filePath;

/**
 *  添加
 */
-(void) doAdd;
@end
