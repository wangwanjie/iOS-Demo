//
//  DWPromptAnimation.m
//  DWPromptAnimationTest
//
//  Created by dwang_sui on 16/8/26.
//  Copyright © 2016年 dwang_sui. All rights reserved.
//

#import "DWPromptAnimation.h"
#import "UIImageView+GIFExtension.h"

/** 序列帧动画图 */
UIImageView *animationPictures;

/** 蒙板视图 */
UIView *animationPicturesView;

@implementation DWPromptAnimation

#pragma mark ---自定义序列帧动画／无法修改属性
+ (void)dw_ShowPromptAnimation:(UIView *)view imageName:(NSString *)imageNames imageCount:(int)imageCount imageType:(NSString *)imageType maskView:(BOOL)maskView {
    
    animationPicturesView = [[UIView alloc] initWithFrame:view.frame];;
    
    animationPictures = [[UIImageView alloc] initWithFrame:CGRectMake(animationPicturesView.center.x-animationPicturesView.frame.size.width/4, animationPicturesView.center.y-animationPicturesView.frame.size.width/4, animationPicturesView.frame.size.width/2, animationPicturesView.frame.size.width/2)];
    
    animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
    
    animationPictures.clipsToBounds = YES;
    
    if (maskView) {
        
        animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:0.8];
        
    }
    
    [animationPicturesView addSubview:animationPictures];
    
    [view addSubview:animationPicturesView];
    
    //判断,之前的动画没有运行结束,则不执行此动画
    if (animationPictures.isAnimating) return;
    
    //Array数组,里面存放的是UIImage对象
    NSMutableArray *muArray = [NSMutableArray array];
    
    for (int i = 0; i < imageCount; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@%02d",imageNames,i];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [muArray addObject:image];
    }
    
    animationPictures.animationImages = muArray;
    
    animationPictures.animationRepeatCount = 0;
    
    // 设置图片的运行时间
    animationPictures.animationDuration = animationPictures.animationImages.count * 0.05;
    
    [animationPictures startAnimating];

    
}

#pragma mark ---使用内置序列帧
- (void)dw_ShowPromptAnimation:(UIView *)view SequenceSources:(DWSequenceSources)sequenceSources {
    
    CGFloat number;
    
    if (self.animationPicturesViewRect.size.width) {
        
        animationPicturesView = [[UIView alloc] initWithFrame:self.animationPicturesViewRect];
        
        number = 2;
        
    }else {
        
        animationPicturesView = [[UIView alloc] initWithFrame:view.frame];
        
        number = 4;
        
    }
    
    if (self.animationPicturesRect.size.width) {
        
        animationPictures = [[UIImageView alloc] initWithFrame:self.animationPicturesRect];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = self.clipsToBounds;
        
    }else {
        
        animationPictures = [[UIImageView alloc] initWithFrame:CGRectMake(animationPicturesView.center.x-animationPicturesView.frame.size.width/number, animationPicturesView.center.y-animationPicturesView.frame.size.width/number, animationPicturesView.frame.size.width/2, animationPicturesView.frame.size.width/2)];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = YES;
        
    }
    
    if (self.animationPicturesViewColor) {
        
        animationPicturesView.backgroundColor = self.animationPicturesViewColor;
        
    }else {
        
        if (self.alpha == 0) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else if (self.alpha) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:0.8];
            
        }
    }
    
    [animationPicturesView addSubview:animationPictures];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.textColor) {
        
        label.textColor = self.textColor;
        
    }else {
        
        label.textColor = [UIColor blackColor];
        
    }
    
    label.text = self.promptWords;
    
    if (self.font) {
        
        label.font = [UIFont systemFontOfSize:self.font];
        
    }else {
        
        label.font = [UIFont systemFontOfSize:23];
        
    }
    
    [label sizeToFit];
    
    [animationPicturesView addSubview:label];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [view addSubview:animationPicturesView];
    
    if (animationPictures.isAnimating) return;
    
    //Array数组,里面存放的是UIImage对象
    NSMutableArray *muArray = [NSMutableArray array];
    
    NSString *imageNames;
    
    int imageCount;
    
    switch (sequenceSources) {
        case 0:
            
            imageNames = @"Sources1";
            
            imageCount = 4;
            
            break;
        
        case 1:
            
            imageNames = @"Sources2";
            
            imageCount = 7;
            
            break;
            
        case 2:
            
            imageNames = @"Sources3";
            
            imageCount = 5;
            
            break;
            
        case 3:
            
            imageNames = @"Sources4";
            
            imageCount = 7;
            
            break;
            
        case 4:
            
            imageNames = @"Sources5";
            
            imageCount = 5;
            
            break;
            
        case 5:
            
            imageNames = @"Sources6";
            
            imageCount = 24;
            
            break;
            
        case 6:
            
            imageNames = @"Sources7";
            
            imageCount = 91;
            
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < imageCount; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@_%02d",imageNames,i];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [muArray addObject:image];
    }
    
    animationPictures.animationImages = muArray;
    
    animationPictures.animationRepeatCount = 0;
    
    // 设置图片的运行时间
    if (self.animationDuration && self.animationDuration > 0) {
        
        animationPictures.animationDuration = animationPictures.animationImages.count * self.animationDuration;
        
    }else {
        
        animationPictures.animationDuration = animationPictures.animationImages.count * 0.05;
        
    }
    
    [animationPictures startAnimating];

    
}

#pragma mark ---使用者自己添加序列帧图片
- (void)dw_ShowPromptAnimation:(UIView *)view imageName:(NSString *)imageNames imageCount:(int)imageCount imageType:(NSString *)imageType {
    
    CGFloat number;
    
    if (self.animationPicturesViewRect.size.width) {
        
        animationPicturesView = [[UIView alloc] initWithFrame:self.animationPicturesViewRect];
        
        number = 2;
        
    }else {
        
        animationPicturesView = [[UIView alloc] initWithFrame:view.frame];
        
        number = 4;
        
    }
    
    if (self.animationPicturesRect.size.width) {
        
        animationPictures = [[UIImageView alloc] initWithFrame:self.animationPicturesRect];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = self.clipsToBounds;
        
    }else {
        
        animationPictures = [[UIImageView alloc] initWithFrame:CGRectMake(animationPicturesView.center.x-animationPicturesView.frame.size.width/number, animationPicturesView.center.y-animationPicturesView.frame.size.width/number, animationPicturesView.frame.size.width/2, animationPicturesView.frame.size.width/2)];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = YES;
        
    }
    
    if (self.animationPicturesViewColor) {
        
        animationPicturesView.backgroundColor = self.animationPicturesViewColor;
        
    }else {
        
        if (self.alpha == 0) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else if (self.alpha) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:0.8];
            
        }
    }
    
    [animationPicturesView addSubview:animationPictures];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.textColor) {
        
        label.textColor = self.textColor;
        
    }else {
    
    label.textColor = [UIColor blackColor];
    
    }
    
    label.text = self.promptWords;
    
    if (self.font) {
        
        label.font = [UIFont systemFontOfSize:self.font];
        
    }else {
        
        label.font = [UIFont systemFontOfSize:23];
        
    }
    
    [label sizeToFit];
    
    [animationPicturesView addSubview:label];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [view addSubview:animationPicturesView];
    
    if (animationPictures.isAnimating) return;
    
    //Array数组,里面存放的是UIImage对象
    NSMutableArray *muArray = [NSMutableArray array];
    
    for (int i = 0; i < imageCount; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@%02d",imageNames,i];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [muArray addObject:image];
    }
    
    animationPictures.animationImages = muArray;
    
    animationPictures.animationRepeatCount = 0;
    
    // 设置图片的运行时间
    if (self.animationDuration && self.animationDuration > 0) {
        
        animationPictures.animationDuration = animationPictures.animationImages.count * self.animationDuration;
        
    }else {
        
        animationPictures.animationDuration = animationPictures.animationImages.count * 0.05;
        
    }
    
    [animationPictures startAnimating];
    
}


#pragma mark ---使用者添加GIF图
+ (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFName:(NSString *)gifName maskView:(BOOL)maskView {
    
    animationPicturesView = [[UIView alloc] initWithFrame:view.frame];;
    
    animationPictures = [[UIImageView alloc] initWithFrame:CGRectMake(animationPicturesView.center.x-animationPicturesView.frame.size.width/4, animationPicturesView.center.y-animationPicturesView.frame.size.width/4, animationPicturesView.frame.size.width/2, animationPicturesView.frame.size.width/2)];
    
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:gifName ofType:nil]];
    
    [animationPictures dw_SetImage:imageURL];
    
    animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
    
    animationPictures.clipsToBounds = YES;
    
    if (maskView) {
        
        animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:0.8];
        
    }
    
    [animationPicturesView addSubview:animationPictures];
    
    [view addSubview:animationPicturesView];
    
}

#pragma mark ---使用内置GIF图
- (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFSources:(DWGIFSources)sources {
    
    CGFloat number;
    
    if (self.animationPicturesViewRect.size.width) {
        
        animationPicturesView = [[UIView alloc] initWithFrame:self.animationPicturesViewRect];
        
        number = 2;
        
    }else {
        
        animationPicturesView = [[UIView alloc] initWithFrame:view.frame];
        
        number = 4;
        
    }
    
    if (self.animationPicturesRect.size.width) {
        
        animationPictures = [[UIImageView alloc] initWithFrame:self.animationPicturesRect];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = self.clipsToBounds;
        
    }else {
        
        animationPictures = [[UIImageView alloc] initWithFrame:CGRectMake(animationPicturesView.center.x-animationPicturesView.frame.size.width/number, animationPicturesView.center.y-animationPicturesView.frame.size.width/number, animationPicturesView.frame.size.width/2, animationPicturesView.frame.size.width/2)];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = YES;
        
    }
    
    if (self.animationPicturesViewColor) {
        
        animationPicturesView.backgroundColor = self.animationPicturesViewColor;
        
    }else {
        
        if (self.alpha == 0) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else if (self.alpha) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:0.8];
            
        }
    }
    
    NSString *sourceString;
    
    switch (sources) {
        case 0:
            sourceString = @"Sources1.gif";
            break;
        
        case 1:
            sourceString = @"Sources2.gif";
            break;
            
        case 2:
            sourceString = @"Sources3.gif";
            break;
            
        case 3:
            sourceString = @"Sources4.gif";
            break;
            
        case 4:
            sourceString = @"Sources5.gif";
            break;
            
        case 5:
            sourceString = @"Sources6.gif";
            break;
            
        case 6:
            sourceString = @"Sources7.gif";
            break;
        
        default:
            break;
    }
    
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:sourceString ofType:nil]];
    
    [animationPictures dw_SetImage:imageURL];
    
    [animationPicturesView addSubview:animationPictures];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.textColor) {
        
        label.textColor = self.textColor;
        
    }else {
        
        label.textColor = [UIColor blackColor];
        
    }
    
    label.text = self.promptWords;
    
    if (self.font) {
        
        label.font = [UIFont systemFontOfSize:self.font];
        
    }else {
        
        label.font = [UIFont systemFontOfSize:23];
        
    }
    
    [label sizeToFit];
    
    [animationPicturesView addSubview:label];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    
    [view addSubview:animationPicturesView];

    
}

#pragma mark ---使用者可自定义GIF图层
- (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFName:(NSString *)gifName {
    
    CGFloat number;
    
    if (self.animationPicturesViewRect.size.width) {
        
        animationPicturesView = [[UIView alloc] initWithFrame:self.animationPicturesViewRect];
        
        number = 2;
        
    }else {
        
        animationPicturesView = [[UIView alloc] initWithFrame:view.frame];
        
        number = 4;
        
    }
    
    if (self.animationPicturesRect.size.width) {
        
        animationPictures = [[UIImageView alloc] initWithFrame:self.animationPicturesRect];
        
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = self.clipsToBounds;
        
    }else {
    
    animationPictures = [[UIImageView alloc] initWithFrame:CGRectMake(animationPicturesView.center.x-animationPicturesView.frame.size.width/number, animationPicturesView.center.y-animationPicturesView.frame.size.width/number, animationPicturesView.frame.size.width/2, animationPicturesView.frame.size.width/2)];
    
        animationPictures.layer.cornerRadius = animationPictures.frame.size.width / 2;
        
        animationPictures.clipsToBounds = YES;
        
    }
    
    if (self.animationPicturesViewColor) {
        
        animationPicturesView.backgroundColor = self.animationPicturesViewColor;
        
    }else {
        
        if (self.alpha == 0) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else if (self.alpha) {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:self.alpha];
            
        }else {
            
            animationPicturesView.backgroundColor = [UIColor colorWithRed:167/255 green:165/255 blue:167/255 alpha:0.8];
            
        }

    }
    
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:gifName ofType:nil]];
    
    [animationPictures dw_SetImage:imageURL];
    
    [animationPicturesView addSubview:animationPictures];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.textColor) {
        
        label.textColor = self.textColor;
        
    }else {
        
        label.textColor = [UIColor blackColor];
        
    }
    
    label.text = self.promptWords;
    
    if (self.font) {
        
        label.font = [UIFont systemFontOfSize:self.font];
        
    }else {
        
        label.font = [UIFont systemFontOfSize:23];
        
    }
    
    [label sizeToFit];
    
    [animationPicturesView addSubview:label];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [animationPicturesView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animationPictures attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    
    [view addSubview:animationPicturesView];
    
}


#pragma mark ---停止
+ (void)dw_stopPromptAnimation {
    
    animationPictures.animationImages = nil;
    
    [animationPictures stopAnimating];
    
    [animationPicturesView removeFromSuperview];
    
}

@end
