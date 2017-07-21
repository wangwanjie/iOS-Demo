//
//  coverView.h
//  version
//
//  Created by zhou on 16/6/14.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class coverView;

@protocol coverViewDelegate <NSObject>

@optional
- (void)coverView:(coverView *)control andWithHegiht:(CGFloat)height;
- (void)closeCoverView:(coverView *)control;//关闭
- (void)updateCoverView:(coverView *)control;//更新
@end

@interface coverView : UIView

+ (instancetype)coverLoad;
- (void)contentUpdateUI:(NSString *)content;

@property (nonatomic,weak) id delegate;
@end
