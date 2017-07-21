# DWPromptAnimation
---
#加载等待视图
##允许自定义蒙板与动画视图，内置7种加载模式与14种自定义GIF加载动画,如果内置的7种无法满足您的需求，可以使用自定义中的GIF图。
#当然也支持您自己的序列帧与GIF
#如果感觉不错，请点击Star
#使用中如果遇到问题,可以加群:577506623
![image](https://github.com/dwanghello/DWPromptAnimation/blob/master/DWPromptAnimation.gif)
---
#Cocoapods
###platform :ios, '8.0'
###pod 'DWPromptAnimation'
---
####导入ImageIO.framework库
####在需要使用的地方导入头文件
	#import "DWPromptAnimation.h"
---
#序列帧
	/**
	 *  自定义序列帧动画/无法修改属性
 	 *
 	 *  @param view       动画添加位置
 	 *  @param imageNames 序列帧图片名称(序号之前)
 	 *  @param imageCount 图片总量，最大为99
 	 *  @param imageType  图片类型/png、jpg
 	 *  @param maskView   是否显示蒙板
 	 */
	+ (void)dw_ShowPromptAnimation:(UIView *)view 
			imageName:(NSString *)imageNames 
			imageCount:(int)imageCount 
			imageType:(NSString *)imageType 
			maskView:(BOOL)maskView;
	
---
	/**
 	 *  使用者设置序列帧/可以自定义一些属性
	 *
 	 *  @param view       动画添加位置
 	 *  @param imageNames 序列帧图片名称(序号之前)
	 *  @param imageCount 图片总量，最大为99
 	 *  @param imageType  图片类型/png、jpg
	 */
	- (void)dw_ShowPromptAnimation:(UIView *)view 
			imageName:(NSString *)imageNames 
			imageCount:(int)imageCount 
			imageType:(NSString *)imageType;
	
---
	/**
 	 *  开始设置内置序列帧图/可以自定义一些属性
	 *
 	 *  @param view            动画添加位置
	 *  @param sequenceSources 内置的一些序列动画
	 */
	- (void)dw_ShowPromptAnimation:(UIView *)view SequenceSources:(DWSequenceSources)sequenceSources;

---
#GIF
	/**
	 *  使用者设置GIF图/无法修改属性
 	 *
	 *  @param view    动画添加位置
	 *  @param gifName GIF图名称
	 *  @param maskView 是否显示蒙板
	 */
	+ (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFName:(NSString *)gifName maskView:(BOOL)maskView;
---
	/**
 	 *
 	 *  使用内置GIF图/可以自定义一些属性
 	 *  @param sources 内置的一些GIF图
 	 *  @param view 动画添加位置
 	 */
	- (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFSources:(DWGIFSources)sources;
---
	/**
 	 *
 	 *  使用者设置GIF图/可以自定义一些属性
 	 *
 	 *  @param view 动画添加位置
 	 */
	- (void)dw_ShowPromptGIFAnimation:(UIView *)view GIFName:(NSString *)gifName;
---
# 自定义显示文字
	/** 提示文字 */
	@property (copy, nonatomic) NSString *promptWords;

	/** 提示文字颜色 */
	@property (strong, nonatomic) UIColor *textColor;

	/** 提示文字字体大小 */
	@property (assign, nonatomic) CGFloat font;
---
#停止动画
	/**
 	 *
 	 *  停止动画
  	 */
	+ (void)dw_stopPromptAnimation;

