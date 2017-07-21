//
//  UIButton+create.h
//  折叠行
//
//  Created by yangyu on 16/4/1.
//  Copyright © 2016年 yangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (create)


+ (UIButton *) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed;

+ (UIButton *) createButtonWithFrame: (CGRect) frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector;

@end
