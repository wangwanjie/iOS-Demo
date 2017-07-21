//
//  SkinTool.m
//  05-换肤
//
//  Created by xiaomage on 15/11/7.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "SkinTool.h"

#define kTheme @"skinTheme"

@implementation SkinTool


+ (void)setSkin:(ThemeType)themeType
{
    
    NSString *path;
    switch (themeType) {
        case kThemeTypeCJ:
            path = @"chunjie";
            break;
        case kThemeTypeZQ:
            path = @"zhongqiu";
            break;
        case kThemeTypeGQ:
            path = @"guoqing";
            break;
            
        default:
            break;
    }
    
    // 使用用户偏好, 记录当前用户选中的主题
    [[NSUserDefaults standardUserDefaults] setObject:path forKey:kTheme];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (UIImage *)getImageWithType:(ImageType)type
{
    // 1. 取出主题
    NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kTheme];
    NSString *path;

    switch (type) {
        case kImageTypeBack:
            path = [NSString stringWithFormat:@"Skin/%@/back.png", themeName];
            break;
        case kImageTypeIcon:
            path = [NSString stringWithFormat:@"Skin/%@/icon.png", themeName];
            break;
        default:
            break;
    }

    return [UIImage imageNamed:path];
}



+ (UIColor *)getColor:(ColorType)colorType
{
    
    // 1. 获取当前主题
     NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kTheme];
    
    // 2. 拼接存储颜色配置的文件路径
    NSString *path = [NSString stringWithFormat:@"Skin/%@/", themeName];
    
    // 2.1 拼接全路径
   path = [[NSBundle mainBundle] pathForResource:@"ColorConfig.plist" ofType:nil inDirectory:path];
    
    // 3. 取出文件存储的颜色数据
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *colorStr;
    // 4. 查看外界到底想要获取当前主题下的什么颜色
    switch (colorType) {
        case kColorTypeLabel:
            colorStr = dic[@(kColorTypeLabel).stringValue];
            break;
        case kColorTypeFore:
            colorStr = dic[@(kColorTypeFore).stringValue];
            break;
            
        default:
            break;
    }
    
    NSArray *colorArray = [colorStr componentsSeparatedByString:@","];
    
    UIColor *color = [UIColor colorWithRed:[colorArray[0] floatValue] / 255.0 green:[colorArray[1] floatValue] / 255.0 blue:[colorArray[2] floatValue] / 255.0 alpha:1];
    
    
    return color;
}


@end
