//
//  ViewProperty.h
//  XML
//
//  Created by mac on 16/7/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewProperty : NSObject
@property (nonatomic,copy)NSString *rect_x;
@property (nonatomic,copy)NSString *rect_y;
@property (nonatomic,copy)NSString *rect_w;
@property (nonatomic,copy)NSString *rect_h;

@property (nonatomic,copy)NSString *backgroundColor_red;
@property (nonatomic,copy)NSString *backgroundColor_green;
@property (nonatomic,copy)NSString *backgroundColor_blue;
@property (nonatomic,copy)NSString *backgroundColor_alpha;

@property (nonatomic,copy)NSString *titleColor_red;
@property (nonatomic,copy)NSString *titleColor_green;
@property (nonatomic,copy)NSString *titleColor_blue;
@property (nonatomic,copy)NSString *titleColor_alpha;

@property (nonatomic,copy)NSString *textColor_red;
@property (nonatomic,copy)NSString *textColor_green;
@property (nonatomic,copy)NSString *textColor_blue;
@property (nonatomic,copy)NSString *textColor_alpha;

@property (nonatomic,copy)NSString *pointSize;//字体大小
@property (nonatomic,copy)NSString *numberOfLines;
@property (nonatomic,copy)NSString *alpha;
@property (nonatomic,copy)NSString *contentMode;
@property (nonatomic,copy)NSString *style;
@property (nonatomic,copy)NSString *adjustsFontSizeToFit;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *textAlignment;
@property (nonatomic,copy)NSString *rowHeight;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *backgroundImage;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *selector;
@property (nonatomic,copy)NSString *eventType;
@property (nonatomic,copy)NSString *segment;
@property (nonatomic,copy)NSString *clearButtonMode;
@property (nonatomic,copy)NSString *on;
@property (nonatomic,copy)NSString *placeholder;

@property (nonatomic,copy)NSString *reuseIdentifier;

- (BOOL)hasProperty:(NSString *)property;

@end