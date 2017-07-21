//
//  ViewProperty.m
//  XML
//
//  Created by mac on 16/7/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewProperty.h"

@implementation ViewProperty
- (BOOL)hasProperty:(NSString *)property{
    NSString *propertys=@"_reuseIdentifier_placeholder_on_clearButtonMode_image_pointSize_alpha_contentMode_style_adjustsFontSizeToFit_text_textAlignment_rowHeight_title_type_backgroundImage_selector_eventType_segment_numberOfLines_";
    
    if ([propertys rangeOfString:[NSString stringWithFormat:@"_%@_",property]].location!=NSNotFound) {
        return YES;
    }
    return NO;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"Property不存在这个属性%@",key);
}
@end