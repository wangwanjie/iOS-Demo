//
//  ZHAlertAction.h
//  application的相关属性和方法
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZHAlertActionBlock)();
typedef void (^ZHAlertActionStringBlock)(NSString *str);
typedef void (^ZHAlertActionTwoStringBlock)(NSString *str1,NSString *str2);

@interface ZHAlertAction : NSObject
/**最简单的警告框*/
- (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet;
/**最简单的警告框,带确定点击方法执行*/
- (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet;
/**带自定义title的警告框,带确定点击方法执行*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet;
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet;
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体 和 自定义取消和确定按钮的Title*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle ActionSheet:(BOOL)actionSheet;

/**带多个选择的的警告框,带确多个方法执行和取消的方法执行体*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet otherButtonBlocks:(NSArray *)blocks otherButtonTitles:(NSString *)otherButtonTitles, ...;


/**最简单的警告框*/
+ (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet;
/**最简单的警告框,带确定点击方法执行*/
+ (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet;
/**带自定义title的警告框,带确定点击方法执行*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet;
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet;
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体 和 自定义取消和确定按钮的Title*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle ActionSheet:(BOOL)actionSheet;

/**带多个选择的的警告框,带确多个方法执行和取消的方法执行体*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet otherButtonBlocks:(NSArray *)blocks otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**带两个输入框*/
+ (void)showTwoTextEntryAlertTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionTwoStringBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle onePlaceHold:(NSString *)onePlaceHold twoPlaceHold:(NSString *)twoPlaceHold;

/**带一个输入框*/
+ (void)showOneTextEntryAlertTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionStringBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle onePlaceHold:(NSString *)onePlaceHold;
@end