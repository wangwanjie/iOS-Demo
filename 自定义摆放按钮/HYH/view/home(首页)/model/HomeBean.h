//
//  HomeBean.h
//  CZYTH_04
//
//  Created by yu on 15/9/6.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeBean : NSObject

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *image;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)homeBeanWithDict:(NSDictionary *)dict;

@end
