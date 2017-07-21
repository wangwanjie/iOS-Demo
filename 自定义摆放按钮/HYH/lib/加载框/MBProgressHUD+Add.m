//
//  MBProgressHUD+Add.m
//  DCOA
//
//  Created by 薛伟俊 on 15/1/21.
//  Copyright (c) 2015年 薛伟俊. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)
+(void)showMessage:(NSString *)message
{
    MBProgressHUD *hud=[[MBProgressHUD alloc]init];
    hud.labelText=message;
    hud.dimBackground=YES;
    UIWindow *window= [UIApplication sharedApplication].windows[0];
    [window addSubview:hud];
    [hud show:YES];
}

+(void)showError:(NSString *)error
{
    MBProgressHUD *hud=[[MBProgressHUD alloc]init];
    hud.labelText=error;
    hud.mode=MBProgressHUDModeCustomView;
    UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    imv.image=[UIImage imageNamed:@"error.png"];
    hud.customView=imv;
    UIWindow *window= [UIApplication sharedApplication].windows[0];
    [window addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{sleep(2);} completionBlock:^{[hud removeFromSuperview];}];
}


+(void)showSuccess:(NSString *)message
{
    MBProgressHUD *hud=[[MBProgressHUD alloc]init];
    hud.labelText=message;
    hud.dimBackground=YES;
    UIWindow *window= [UIApplication sharedApplication].windows[0];
    [window addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{sleep(1);} completionBlock:^{[hud removeFromSuperview];}];
}


+(void)hideHUD
{
    UIWindow *window= [UIApplication sharedApplication].windows[0];
    [MBProgressHUD hideHUDForView:window animated:YES];
}
@end
