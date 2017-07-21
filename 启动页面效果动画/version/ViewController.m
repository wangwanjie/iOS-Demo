//
//  ViewController.m
//  version
//
//  Created by zhou on 16/6/14.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
#import "coverView.h"

#define AppStore_ID @"444934666"

@interface ViewController ()<SKStoreProductViewControllerDelegate,coverViewDelegate>


@property (nonatomic, strong) coverView *showView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkVerSion];
}
- (void)checkVerSion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //取出当前软件的版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appPackageName = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        //拿到App Store上的软件的版本号
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",AppStore_ID]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            
            if (data)
                
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                
                NSArray *infoArray = [dic objectForKey:@"results"];
                
                if ([infoArray isKindOfClass:[NSArray class]] && [infoArray count]>0)
                    
                {
                    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                    
                    NSString *appstoreVersion = [releaseInfo objectForKey:@"version"];
                    
                    // NSLog(@"%@===%@",appPackageName,appstoreVersion);
                    if ([appPackageName isEqual:appstoreVersion])
                    {
                        
                        /*记录下来的和appstoreVersion相比, 相同的表示已经检查过的版本,不需要在去提示*/
                        
                        NSLog(@"appstoreVersion");
                        
                        return ;
                        
                    }else
                        
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self updateVersion];
                            
                        });
                    }
                }
                
            }
            
        }];
        
        [dataTask resume];
        
        
    });
    
}
//跟新版本号
- (void)updateVersion
{
    UIView *cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.tag = 1;
    
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    [self.view addSubview:cover];
    
    coverView *showView = [coverView coverLoad];
    self.showView = showView;
    showView.delegate = self;
    showView.center = cover.center;
    
    showView.layer.cornerRadius = 5;
    showView.clipsToBounds = YES;
    
    [cover addSubview:showView];
    
    NSString *str = @"更新内容：\n～第一条信息\n～第二条信息\n～第三条信息\n～第四条信息";
    [showView contentUpdateUI:str];
    

    [self shakeToShow:showView];
}
//显示提示框的动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

//计算view的高度
- (void)coverView:(coverView *)control andWithHegiht:(CGFloat)height
{
    self.showView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-100, height);
}
//关闭
- (void)closeCoverView:(coverView *)control
{
    [self removeUI];
}
//更新
- (void)updateCoverView:(coverView *)control
{
    [self openAppWithIdentifier];
}
- (void)removeUI
{
    for (int i = 0; i < self.view.subviews.count; i++) {
        UIView *v = self.view.subviews[i];
        if ([v isKindOfClass:[UIView class]] && v.tag == 1) {
            [v removeFromSuperview];
        }
    }
    //    [self.view removeFromSuperview];
}

//动态计算高度
//-(CGFloat)getHeightWithTitle:(NSString *)title andFont:(NSInteger)fontsize
//{
//    CGFloat height = [title boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size.height;
//    return height;
//}

/**
 *  应用内打开Appstore
 */
- (void)openAppWithIdentifier{
    dispatch_async(dispatch_get_main_queue(), ^{
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        storeProductVC.delegate = self;
        
        //AppStore_ID
        NSDictionary *dict = [NSDictionary dictionaryWithObject:AppStore_ID forKey:SKStoreProductParameterITunesItemIdentifier];
        
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                UIWindow *window = nil;
                id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
                if ([delegate respondsToSelector:@selector(window)]) {
                    window = [delegate performSelector:@selector(window)];
                } else {
                    window = [[UIApplication sharedApplication] keyWindow];
                }
                [window.rootViewController presentViewController:storeProductVC animated:YES completion:nil];
            }
        }];
    });
}

@end
