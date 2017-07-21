//
//  ChangYong_NSObject.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/30.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "ChangYong_NSObject.h"

@implementation ChangYong_NSObject

/**
 判断空值
 */
+ (NSString *) selectNulString:(NSString *)stye{

    if ( (NSNull *) stye ==  [[NSNull alloc] init]) {
        
        return  @"";
    }else{

        return stye;
    }
}

/**
 拿两位小数
 */
+ (NSString *) twoDouble: (double)a{

    float b = a;
    NSString *c = [NSString stringWithFormat:@"%.2f",b];

    return  c;
}

/**
 * 得到当前时间
 *  @return<#return value description#>
 */
+(NSString *) DanQianTime{

    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；

    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
    NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；

    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    //然后就可以从d中获取具体的年月日了；
    NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day  =  [d day];

    NSString *month_string;
    NSString *day_string;

    if (month < 10) {
        month_string = [NSString stringWithFormat:@"%@%d",@"0",(int)month];
    }else{
        month_string = [NSString stringWithFormat:@"%d",(int)month];
    }

    if (day < 10) {
        day_string = [NSString stringWithFormat:@"%@%d",@"0",(int)day];
    }else{
        day_string = [NSString stringWithFormat:@"%d",(int)day];
    }
    return [NSString stringWithFormat:@"%d-%@-%@",(int)year,month_string,day_string];
}

@end
