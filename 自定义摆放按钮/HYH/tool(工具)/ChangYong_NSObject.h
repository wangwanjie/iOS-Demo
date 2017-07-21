//
//  ChangYong_NSObject.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/30.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangYong_NSObject : NSObject

/**
 拿两位小数
 */
+ (NSString *) twoDouble: (double)a;

/**
 判断空值
 */
+ (NSString *) selectNulString:(NSString *)stye;

/**
 *得到当前时间
 *  @return <#return value description#>
 */
+(NSString *) DanQianTime;
@end
