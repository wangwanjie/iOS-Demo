//
//  UIButton+create.m
//  折叠行
//
//  Created by yangyu on 16/4/1.
//  Copyright © 2016年 yangyu. All rights reserved.
//

#import "UIButton+create.h"

@implementation UIButton (create)

+(UIButton *) createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    
    UIImage *newImage = [UIImage imageNamed:image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    UIImage *newPressedImage = [UIImage imageNamed:imagePressed];
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;

}


+(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
    
    
}

@end
