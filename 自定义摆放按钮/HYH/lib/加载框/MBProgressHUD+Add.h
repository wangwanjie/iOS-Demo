//
//  MBProgressHUD+Add.h
//  DCOA
//
//  Created by 薛伟俊 on 15/1/21.
//  Copyright (c) 2015年 薛伟俊. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+(void)showMessage:(NSString *)message;
+(void)showError:(NSString *)error;
+(void)hideHUD;
+(void)showSuccess:(NSString *)message;
@end
