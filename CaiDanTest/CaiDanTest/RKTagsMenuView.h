//
//  RKTagsMenuView.h
//  RKTopTagsMenu
//
//  Created by Roki Liu on 16/3/8.
//  Copyright © 2016年 Snail. All rights reserved.
//  KMJ二次加工

#import <UIKit/UIKit.h>

@interface RKTagsMenuView : UIView

//点击某一个图片回调
@property(nonatomic,copy)void (^didSelectTagBlock)(NSInteger clickedRow);

@property (nonatomic, strong) UIColor *titleColor;   //标签字体颜色(选中状态，默认为白色)
@property (nonatomic, assign) CGFloat  titleSize;    //标签字体大小
@property (nonatomic, assign) CGFloat  tagSpace;     //标签内部左右间距(标题距离边框2边的距离和)
@property (nonatomic, assign) CGFloat  tagHorizontalSpace; //标签间横向间距
@property (nonatomic, assign) CGFloat  tagOriginX;   //第一个标签起点X坐标
@property (nonatomic,assign) CGFloat flagLastTitleWidth; //记录最后一个标签的宽度

//设置标签数组
- (void)setTagsArray:(NSArray *)tagsAry;

@end

#pragma mark - 扩展方法

@interface NSString (FDDExtention)

- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
