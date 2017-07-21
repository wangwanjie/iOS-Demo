//
//  HomeBean.m
//  CZYTH_04
//
//  Created by yu on 15/9/6.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import "HomeBean.h"

@implementation HomeBean

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype) homeBeanWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

@end
