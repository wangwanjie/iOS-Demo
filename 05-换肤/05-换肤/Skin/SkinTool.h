//
//  SkinTool.h
//  05-换肤
//
//  Created by xiaomage on 15/11/7.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    kThemeTypeCJ,
    kThemeTypeZQ,
    kThemeTypeGQ
  
}ThemeType;


typedef enum
{
    kImageTypeBack,
    kImageTypeIcon
}ImageType;


typedef enum
{
    kColorTypeLabel,
    kColorTypeFore
}ColorType;


@interface SkinTool : NSObject

+ (void)setSkin:(ThemeType)themeType;

+ (UIImage *)getImageWithType:(ImageType)type;


+ (UIColor *)getColor:(ColorType)colorType;

@end
