//
//  ReplaceTextField.h
//  实用功能性测试
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplaceTextField : UITextField
<UITextFieldDelegate>
@property(nonatomic,assign)NSInteger headLength;
@property(nonatomic,assign)NSInteger footLength;
@property(nonatomic,strong,readonly)NSString *rememberText;
@end
