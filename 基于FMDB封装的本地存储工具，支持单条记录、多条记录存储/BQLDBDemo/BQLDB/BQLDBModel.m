//
//  BQLDBModel.m
//  BQLDB
//
//  Created by 毕青林 on 16/5/31.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "BQLDBModel.h"
#import <objc/runtime.h>

@implementation BQLDBModel

+ (instancetype)modelWithDictionary:(NSDictionary*)dictionary {
    
    id obj = [[self alloc] init];
    for (NSString *originKey in dictionary.allKeys) {
        
        NSString *key = [originKey lowercaseString];
        if ([[self getAllKeys] containsObject:key]) {
            
            id value = dictionary[originKey];
            if ([value isKindOfClass:[NSNull class]]) {
                continue;
            }
            [obj setValue:value forKey:key];
        }
        else {
            
            continue;
        }
    }
#warning 如果你要换customID名称，记得这里也要换哦!
    if(dictionary[@"customid"]) {
        [obj setValue:dictionary[@"customid"] forKey:@"customID"];
    }
    
    return obj;
}

- (NSDictionary*)dictionaryWithModel {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *key in [[self class] getAllKeys]) {
        
        id value = [self valueForKey:key];
        if (value != nil) {
            
            if ([value isKindOfClass:[NSArray class]]) {
                if ([value count]==0) {
                    continue;
                }
            }
            else if ([value isKindOfClass:[NSString class]]) {
                if ([value length]==0) {
                    continue;
                }
            }
            [dictionary setValue:[self valueForKey:key] forKey:key];
        }
        else {
            
            continue;
        }
    }
    return dictionary;
}

+ (NSArray *)getAllKeys {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    
    free(properties);
    return props;
}

- (NSArray*)getAllKeys {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    
    free(properties);
    return props;
}

- (NSArray *)getAllValues {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSDictionary *dictionary = [self dictionaryWithModel];
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id value = [dictionary objectForKey:propertyName];
        if(value == nil || [value isKindOfClass:[NSNull class]]) {
            value = @"";
        }
        [props addObject:value];
    }
    
    free(properties);
    return props;
}

@end






