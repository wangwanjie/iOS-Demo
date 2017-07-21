//
//  ZHAlertAction.m
//  application的相关属性和方法
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZHAlertAction.h"


static ZHAlertAction * zhAlertActionDefault;
@interface ZHAlertAction ()

@property (nonatomic,strong)UIAlertAction *okAlertAction;
@property (nonatomic,strong)UITextField *textFieldOne;
@property (nonatomic,strong)UITextField *textFieldTwo;

@end
@implementation ZHAlertAction
+ (ZHAlertAction *)AlertAction{
    zhAlertActionDefault=[ZHAlertAction new];
    return zhAlertActionDefault;
}
/**最简单的警告框*/
+ (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet{
    [[self AlertAction]alertWithMsg:msg addToViewController:viewController ActionSheet:actionSheet];
}
/**最简单的警告框,带确定点击方法执行*/
+ (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet{
    [[self AlertAction]alertWithMsg:msg addToViewController:viewController withOkBlock:okBlock ActionSheet:actionSheet];
}
/**带自定义title的警告框,带确定点击方法执行*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet{
    [[self AlertAction]alertWithTitle:title withMsg:msg addToViewController:viewController withOkBlock:okBlock ActionSheet:actionSheet];
}
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet{
    [[self AlertAction]alertWithTitle:title withMsg:msg addToViewController:viewController withCancleBlock:cancleBlock withOkBlock:okBlock ActionSheet:actionSheet];
}
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体 和 自定义取消和确定按钮的Title*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle ActionSheet:(BOOL)actionSheet{
    [[self AlertAction] alertWithTitle:title withMsg:msg addToViewController:viewController withCancleBlock:cancleBlock withOkBlock:okBlock cancelButtonTitle:cancelButtonTitle OkButtonTitle:OkButtonTitle ActionSheet:actionSheet];
}

/**带多个选择的的警告框,带确多个方法执行和取消的方法执行体*/
+ (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet otherButtonBlocks:(NSArray *)blocks otherButtonTitles:(NSString *)otherButtonTitles, ...{
    [[self AlertAction]alertWithTitle:title withMsg:msg addToViewController:viewController ActionSheet:actionSheet otherButtonBlocks:blocks otherButtonTitles:otherButtonTitles];
}

/**带两个输入框*/
+ (void)showTwoTextEntryAlertTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionTwoStringBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle onePlaceHold:(NSString *)onePlaceHold twoPlaceHold:(NSString *)twoPlaceHold{
    [[self AlertAction] showTwoTextEntryAlertTitle:title withMsg:msg addToViewController:viewController withCancleBlock:cancleBlock withOkBlock:okBlock cancelButtonTitle:cancelButtonTitle OkButtonTitle:OkButtonTitle onePlaceHold:onePlaceHold twoPlaceHold:twoPlaceHold];
}

/**带一个输入框*/
+ (void)showOneTextEntryAlertTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionStringBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle onePlaceHold:(NSString *)onePlaceHold{
    [[self AlertAction] showOneTextEntryAlertTitle:title withMsg:msg addToViewController:viewController withCancleBlock:cancleBlock withOkBlock:okBlock cancelButtonTitle:cancelButtonTitle OkButtonTitle:OkButtonTitle onePlaceHold:onePlaceHold];
}


/**最简单的警告框*/
- (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet{
    [self alertWithTitle:@"温馨提示" withMsg:msg addToViewController:viewController withOkBlock:nil ActionSheet:actionSheet];
}
/**最简单的警告框,带确定点击方法执行*/
- (void)alertWithMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet{
    [self alertWithTitle:@"温馨提示" withMsg:msg addToViewController:viewController withOkBlock:okBlock ActionSheet:actionSheet];
}
/**带自定义title的警告框,带确定点击方法执行*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(actionSheet?UIAlertControllerStyleActionSheet:UIAlertControllerStyleAlert)];
    __weak typeof(alertController) weakAlertController=alertController;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okBlock!=nil)okBlock();
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}
/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock ActionSheet:(BOOL)actionSheet{
    
    [self alertWithTitle:title withMsg:msg addToViewController:viewController withCancleBlock:cancleBlock withOkBlock:okBlock cancelButtonTitle:@"取消" OkButtonTitle:@"确定" ActionSheet:actionSheet];
}

/**带自定义title的警告框,带确定点击方法执行和取消的方法执行体 和 自定义取消和确定按钮的Title*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle ActionSheet:(BOOL)actionSheet{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(actionSheet?UIAlertControllerStyleActionSheet:UIAlertControllerStyleAlert)];
    
    __weak typeof(alertController) weakAlertController=alertController;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(cancleBlock!=nil)cancleBlock();
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OkButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(okBlock!=nil)okBlock();
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}


/**带多个选择的的警告框,带确多个方法执行和取消的方法执行体*/
- (void)alertWithTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController ActionSheet:(BOOL)actionSheet otherButtonBlocks:(NSArray *)blocks otherButtonTitles:(NSString *)otherButtonTitles, ...{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(actionSheet?UIAlertControllerStyleActionSheet:UIAlertControllerStyleAlert)];
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    if (otherButtonTitles.length>0) {
        [arrM addObject:otherButtonTitles];
    }
    
    va_list args;
    va_start(args, otherButtonTitles);
    if (otherButtonTitles)
    {
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *)))
        {
            [arrM addObject:otherString];
        }
    }
    va_end(args);
    
    typedef void(^MyblockWithNULL)(void);
    __weak typeof(alertController) weakAlertController=alertController;
    for (NSString *title in arrM) {
        NSInteger index=[arrM indexOfObject:title];
        if (index>=blocks.count) {
            break;
        }
        UIAlertAction *Action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (blocks[index]!=nil) {
                MyblockWithNULL block=blocks[index];
                block();
            }
            [weakAlertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:Action];
    }
    
    if (![arrM containsObject:@"取消"]) {
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakAlertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:CancelAction];
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

/**带两个输入框*/
- (void)showTwoTextEntryAlertTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionTwoStringBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle onePlaceHold:(NSString *)onePlaceHold twoPlaceHold:(NSString *)twoPlaceHold{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        zhAlertActionDefault.textFieldOne=textField;
        if (onePlaceHold.length>0) {
            zhAlertActionDefault.textFieldOne.placeholder=onePlaceHold;
        }
        [[NSNotificationCenter defaultCenter] addObserver:zhAlertActionDefault selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        zhAlertActionDefault.textFieldTwo=textField;
        if (twoPlaceHold.length>0) {
            zhAlertActionDefault.textFieldTwo.placeholder=twoPlaceHold;
        }
        [[NSNotificationCenter defaultCenter] addObserver:zhAlertActionDefault selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        if (cancleBlock!=nil) {
            cancleBlock();
        }
        
        [zhAlertActionDefault removeObserver];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:OkButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (okBlock!=nil) {
            okBlock(zhAlertActionDefault.textFieldOne.text,zhAlertActionDefault.textFieldTwo.text);
        }
        
        [zhAlertActionDefault removeObserver];
    }];
    
    zhAlertActionDefault.okAlertAction=otherAction;
    
    otherAction.enabled = NO;
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

/**带一个输入框*/
- (void)showOneTextEntryAlertTitle:(NSString *)title withMsg:(NSString *)msg addToViewController:(UIViewController *)viewController withCancleBlock:(ZHAlertActionBlock)cancleBlock withOkBlock:(ZHAlertActionStringBlock)okBlock cancelButtonTitle:(NSString *)cancelButtonTitle OkButtonTitle:(NSString *)OkButtonTitle onePlaceHold:(NSString *)onePlaceHold{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        zhAlertActionDefault.textFieldOne=textField;
        if (onePlaceHold.length>0) {
            zhAlertActionDefault.textFieldOne.placeholder=onePlaceHold;
        }
        [[NSNotificationCenter defaultCenter] addObserver:zhAlertActionDefault selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        if (cancleBlock!=nil) {
            cancleBlock();
        }
        
        [zhAlertActionDefault removeObserver];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:OkButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (okBlock!=nil) {
            okBlock(zhAlertActionDefault.textFieldOne.text);
        }
        
        [self removeObserver];
    }];
    
    zhAlertActionDefault.okAlertAction=otherAction;
    
    otherAction.enabled = NO;
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)removeObserver{
    if (zhAlertActionDefault.textFieldOne) {
        [[NSNotificationCenter defaultCenter] removeObserver:zhAlertActionDefault name:UITextFieldTextDidChangeNotification object:zhAlertActionDefault.textFieldOne];
        zhAlertActionDefault.textFieldOne=nil;
    }
    if (zhAlertActionDefault.textFieldTwo) {
        [[NSNotificationCenter defaultCenter] removeObserver:zhAlertActionDefault name:UITextFieldTextDidChangeNotification object:zhAlertActionDefault.textFieldTwo];
        zhAlertActionDefault.textFieldTwo=nil;
    }
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    if (zhAlertActionDefault.textFieldOne!=nil&&zhAlertActionDefault.textFieldOne.text.length>0) {
        if (zhAlertActionDefault.textFieldTwo!=nil) {
            if (zhAlertActionDefault.textFieldTwo.text.length>0) {
                zhAlertActionDefault.okAlertAction.enabled =YES ;
            }
            return;
        }
        zhAlertActionDefault.okAlertAction.enabled =YES ;
    }
}
@end
