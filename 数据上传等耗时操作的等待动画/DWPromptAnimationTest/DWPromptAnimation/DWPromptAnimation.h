//
//  DWPromptAnimation.h
//  DWPromptAnimationTest
//
//  Created by dwang_sui on 16/8/26.
//  Copyright © 2016年 dwang_sui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** GIF图枚举 */
typedef enum : NSUInteger {
    sources1,
    sources2,
    sources3,
    sources4,
    sources5,
    sources6,
    sources7,
} DWGIFSources;

/** 序列帧枚举 */
typedef enum : NSUInteger {
    sequence1,
    sequence2,
    sequence3,
    sequence4,
    sequence5,
    sequence6,
    sequence7,
} DWSequenceSources;

@interface DWPromptAnimation : NSObject

/** 修改蒙板默认颜色 */
@property (strong, nonatomic) UIColor *animationPicturesViewColor;

/** 设置完成一次的时间/序列帧动画有效 */
@property (assign, nonatomic) NSTimeInterval animationDuration;

/** 修改默认蒙板alpha */
@property (assign, nonatomic) CGFloat alpha;

/** 修改蒙板默认Rect尺寸 */
@property (assign, nonatomic) CGRect animationPicturesViewRect;

/** 修改UIImageView默认Rect尺寸 */
@property (assign, nonatomic) CGRect animationPicturesRect;

/** 修改UIImageView默认Rect尺寸后，是否进行切圆 */
@property (assign, nonatomic) BOOL clipsToBounds;

/** 提示文字 */
@property (copy, nonatomic) NSString *promptWords;

/** 提示文字颜色 */
@property (strong, nonatomic) UIColor *textColor;

/** 提示文字字体大小 */
@property (assign, nonatomic) CGFloat font;

/**
 *  自定义序列帧动画／无法修改属性
 *
 *  @param view       动画添加位置
 *  @param imageNames 序列帧图片名称(序号之前)
 *  @param imageCount 图片总量，最大为99
 *  @param imageType  图片类型/png、jpg
 *  @param maskView   是否显示蒙板
 */
+ (void)dw_ShowPromptAnimation:(UIView *)view imageName:(NSString *)imageNames imageCount:(int)imageCount imageType:(NSString *)imageType maskView:(BOOL)maskView;

/**
 *  使用者设置序列帧/可以自定义一些属性
 *
 *  @param view       动画添加位置
 *  @param imageNames 序列帧图片名称(序号之前)
 *  @param imageCount 图片总量，最大为99
 *  @param imageType  图片类型/png、jpg
 */
- (void)dw_ShowPromptAnimation:(UIView *)view imageName:(NSString *)imageNames imageCount:(int)imageCount imageType:(NSString *)imageType;

/**
 *  开始设置内置序列帧图/可以自定义一些属性
 *
 *  @param view            动画添加位置
 *  @param sequenceSources 内置的一些序列动画
 */
- (void)dw_ShowPromptAnimation:(UIView *)view SequenceSources:(DWSequenceSources)sequenceSources;


/**
 *  使用者设置GIF图/无法修改属性
 *
 *  @param view    动画添加位置
 *  @param gifName GIF图名称
 *  @param maskView 是否显示蒙板
 */
+ (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFName:(NSString *)gifName maskView:(BOOL)maskView;

/**
 *
 *  使用内置GIF图/可以自定义一些属性
 *  @param sources 内置的一些GIF图
 *  @param view 动画添加位置
 */
- (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFSources:(DWGIFSources)sources;

/**
 *
 *  使用者设置GIF图/可以自定义一些属性
 *
 *  @param view 动画添加位置
 */
- (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFName:(NSString *)gifName;

/**
 *
 *  停止动画
 */
+ (void)dw_stopPromptAnimation;

@end
